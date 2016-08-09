module SimpleCaptcha
  class WebSimpleCaptchaData < ::ActiveRecord::Base

    if ::ActiveRecord::VERSION::MAJOR >= 3
      # Fixes deprecation warning in Rails 3.2:
      # DEPRECATION WARNING: Calling set_table_name is deprecated. Please use `self.table_name = 'the_name'` instead.
      self.table_name = "web_simple_captcha_data"
    else
      set_table_name "web_simple_captcha_data"
    end
    if ::ActiveRecord::VERSION::MAJOR == 3 and defined? attr_protected
      attr_protected
    end


    class << self
      def get_data(key)
        where(key: key).first_or_initialize
      end

      def remove_data(key)
        delete_all(["#{connection.quote_column_name(:key)} = ?", key])
        clear_old_data(1.hour.ago)
      end

      def clear_old_data(time = 1.hour.ago)
        return unless Time === time
        delete_all(["#{connection.quote_column_name(:updated_at)} < ?", time])
      end
    end
  end
end
