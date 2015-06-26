# Publisher is the base class for all publisher plugins (e.g., plugins for
# sending e-mails or posting messages to third-party services). All publishers
# should inherit off of this class in order to be called from +Delayed::Job+.

class Publisher < ActiveRecord::Base
  attr_accessible :class_name, :default, :name

  has_many :message_logs
  has_many :messages, :through => :message_logs

  
  # Called from +lib/tasks/bulk_send.rake+ in order to schedule a message to be
  # published.  
  # Params:
  # [+message_log+] +MessageLog+ object associated with the message to be
  #                 sent and the publisher with which to send the message.
  # [+recipient_list+] Array of +Persons+ representing the list of all
  #                    recipients of this message.
  def self.schedule(message_log, recipient_list)
    message_log.send_status = :queued
    message_log.save!

    message = message_log.message

    recipient_list.each do |recipient|
        self.delay.perform(message_log, message, recipient)
    end
  end

  # Makes a message receipt and does the actual publishing/sending of a message.
  # Keeps track of whether or not all messages have been sent.  
  # *Note* that since this method is called from +schedule+ for every single
  # recipient, there is a unique +MessageReceipt+ associated with each recipient,
  # message, and publication medium combination, unless +schedule+ is overriden
  # not to create +MessageReceipts+.
  def self.perform(message_log, message, recipient)
    receipt = MessageReceipt.new
    receipt.recipient_name = recipient.name
    receipt.recipient_email = recipient.email
    receipt.login_id = recipient.loginid?
    message_log.entries << receipt

    self.publish(receipt.id, message, recipient)

    if message_log.entries.length == message_log.recipient_count
      message_log.send_status = :completed
      message_log.finish = Time.now
      message_log.save!
    else
      message_log.send_status = :sending
      message_log.save!
    end
  end

  # <em>Not implemented by default</em>. This method should be implemented in
  # classes that inherit from this class. By default, +perform+ calls this
  # method for every recipient, ideally to send a message to the given
  # recipient.  
  # Params:  
  # [+message_receipt_id+] The id of the +MessageReceipt+ created for the 
  #                        message being sent to the given recipient.
  # [+message+] +Message+ object representing the actual content of the message
  #             being sent. 
  # [+recipient+] +Person+ object representing the recipient of the message.
  def self.publish(message_receipt_id, message, recipient)
  end

  # <em>Not implemented by default</em>. Called from
  # +MessageReceiptsController+. Allows linking a +Publisher+-specific action to
  # a URL.  
  # Params:
  # [+message_receipt_id+] The id of the +MessageReceipt+ object associated with
  #                        the callback. +MessageReceipts+ belong to
  #                        +MessageLogs+ and +Messages+, so lots of attributes
  #                        can be accessed from a +MessageReceipt+'s id.
  #                        Typically used to help count number of views a
  #                        message has received.
  # [+scope+] Scope of the +MessageReceiptsController+. Allows calling
  #           controller actions such as send_file or render.  
  #           Examples:  
  #             # Using scope.instance_eval
  #             scope.instance_eval do
  #               ...
  #               render 'message/show'
  #             end
  #
  #             # Using scope directly.
  #             scope.send_file Rails.root.join("app/assets/images/1x1.gif", :type => 'image/gif'
  def self.callback(message_receipt_id, scope)
  end

  # Safely turns the stored class name into a constant that can be used to call
  # the appropriate methods for the given publisher.
  def classify
    self.class_name.constantize  if # the specified class name is in one of the
                                    # files in app/publishers
      Dir.entries(Rails.root + "app/publishers")
      .map do |x| 
        unless x.start_with?(".") || File.directory?(x) || ! x.end_with?(".rb")
          class_file = File.open(Rails.root + "app/publishers/" + x)
          until class_file.eof()
            class_line = class_file.readline()
            break class_line.gsub(/.* (.*) < Publisher/, '\1').strip  if class_line.include? "< Publisher"
            break if class_line.start_with? "class" 
          end
        end
      end
      .delete_if { |x| x.nil? }
      .uniq
      .include? self.class_name
  end
end
