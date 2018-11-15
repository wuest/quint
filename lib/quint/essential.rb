module Quint
  module Essential
    def sig(*attrs)
      signatures.shift while signatures.any?
      signatures.unshift(attrs)
    end

    private

    def signatures
      if self.instance_variable_defined?(:@__signatures__)
        return self.instance_variable_get(:@__signatures__)
      end
      self.instance_variable_set(:@__signatures__, [])
    end

    def method_added(name)
      return unless signatures.any? && Quint.enabled?

      signature = signatures.shift
      args_sig  = signature[0...-1]
      ret_sig   = signature.last
      original  = instance_method(name)
      error     = "#{name} has signature of #{args_sig.inspect} but received "
      ret_error = "#{name} should return #{ret_sig.inspect} but returned "

      if Quint.mode == :error
        instance_error(name, args_sig, ret_sig, original, error, ret_error)
      else
        instance_warn(name, args_sig, ret_sig, original, error, ret_error)
      end
    end

    def singleton_method_added(name)
      return unless signatures.any? && Quint.enabled?

      signature = signatures.shift
      args_sig  = signature[0...-1]
      ret_sig   = signature.last
      original  = singleton_method(name).unbind
      error     = "#{name} has signature of #{args_sig.inspect} but received "
      ret_error = "#{name} should return #{ret_sig.inspect} but returned "

      if Quint.mode == :error
        singleton_error(name, args_sig, ret_sig, original, error, ret_error)
      else
        singleton_warn(name, args_sig, ret_sig, original, error, ret_error)
      end
    end

    def instance_error(name, args_sig, ret_sig, original, err, ret_err)
      define_method name do |*args|
        args_sig.zip(args).each do |a, b|
          unless b.is_a?(a)
            arg_types = args.map(&:class)
            exception = TypeError.new(err + arg_types.inspect)
            exception.set_backtrace(caller[2..-1])
            raise exception
          end
        end

        ret = original.bind(self).call(*args)

        unless ret.is_a?(ret_sig)
          exception = TypeError.new(ret_err + ret.class.name)
          exception.set_backtrace(caller[2..-1])
          raise exception
        end

        ret
      end
    end

    def instance_warn(name, args_sig, ret_sig, original, err, ret_err)
      define_method name do |*args|
        args_sig.zip(args).each do |a, b|
          unless b.is_a?(a)
            arg_types = args.map(&:class)
            $stderr.puts("#{caller.last} WARNING: " + err + arg_types.inspect)
          end
        end

        ret = original.bind(self).call(*args)

        unless ret.is_a?(ret_sig)
          $stderr.puts("#{caller.last} WARNING: " + ret_err + ret.class.name)
        end

        ret
      end
    end

    def singleton_error(name, args_sig, ret_sig, original, err, ret_err)
      define_singleton_method name do |*args|
        args_sig.zip(args).each do |a, b|
          unless b.is_a?(a)
            arg_types = args.map(&:class)
            exception = TypeError.new(err + arg_types.inspect)
            exception.set_backtrace(caller[2..-1])
            raise exception
          end
        end

        ret = original.bind(self).call(*args)

        unless ret.is_a?(ret_sig)
          exception = TypeError.new(ret_err + ret.class.name)
          exception.set_backtrace(caller[2..-1])
          raise exception
        end

        ret
      end
    end

    def singleton_warn(name, args_sig, ret_sig, original, err, ret_err)
      define_singleton_method name do |*args|
        args_sig.zip(args).each do |a, b|
          unless b.is_a?(a)
            arg_types = args.map(&:class)
            $stderr.puts("#{caller.last} WARNING: " + err + arg_types.inspect)
          end
        end

        ret = original.bind(self).call(*args)

        unless ret.is_a?(ret_sig)
          $stderr.puts("#{caller.last} WARNING: " + ret_err + ret.class.name)
        end

        ret
      end
    end
  end
end
