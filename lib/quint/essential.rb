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

    def target_creator(params)
      req = params.count { |p| p.first == :req } # TODO add :opt support
      if req > 6
        "generic"
      else
        "#{req}pos"
      end
    end

    def method_added(name)
      return unless signatures.any? && Quint.enabled?

      signature = signatures.shift
      original  = instance_method(name)
      creator   = target_creator(original.parameters)
      target_creator = "instance_#{creator}".to_sym

      if Quint.mode == :error
        action = ->(exception) { raise exception }
        method(target_creator).call(name, signature, original, action)
      else
        action = ->(exception) { warn exception.full_message }
        method(target_creator).call(name, signature, original, action)
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

    def instance_generic(name, signature, original, action)
      args_sig = signature[0...-1]
      ret_sig  = signature.last
      err      = "#{name} has signature of #{args_sig.inspect} but received "
      ret_err  = "#{name} should return #{ret_sig.inspect} but returned "

      define_method name do |*args|
        args_sig.zip(args).each do |a, b|
          unless b.is_a?(a)
            arg_types = args.map(&:class)
            exception = TypeError.new(err + arg_types.inspect)
            exception.set_backtrace(caller)
            action.call(exception)
          end
        end

        ret = original.bind(self).call(*args)

        unless ret.is_a?(ret_sig)
          exception = TypeError.new(ret_err + ret.class.name)
          exception.set_backtrace(caller)
          action.call(exception)
        end

        ret
      end
    end

    def instance_0pos(name, (tr), original, action)
      ret_err  = "#{name} should return #{tr.name} but returned "

      define_method name do
        ret = original.bind(self).call()

        unless ret.is_a?(tr)
          exception = TypeError.new(ret_err + ret.class.name)
          exception.set_backtrace(caller)
          action.call(exception)
        end

        ret
      end
    end

    def instance_1pos(name, (ta, tr), original, action)
      err      = "#{name} has signature of #{ta.name} but received "
      ret_err  = "#{name} should return #{tr.name} but returned "

      define_method name do |a|
        unless a.is_a?(ta)
          exception = TypeError.new(err + a.class.name)
          exception.set_backtrace(caller)
          action.call(exception)
        end

        ret = original.bind(self).call(a)

        unless ret.is_a?(tr)
          exception = TypeError.new(ret_err + ret.class.name)
          exception.set_backtrace(caller)
          action.call(exception)
        end

        ret
      end
    end

    def instance_2pos(name, (ta, tb, tr), original, action)
      argstring = [ta, tb].join(',')
      err       = "#{name} has signature of #{argstring} but received "
      ret_err   = "#{name} should return #{tr.name} but returned "

      define_method name do |a, b|
        unless a.is_a?(ta) && b.is_a?(tb)
          exception = TypeError.new(err + a.class.name)
          exception.set_backtrace(caller)
          action.call(exception)
        end

        ret = original.bind(self).call(a, b)

        unless ret.is_a?(tr)
          exception = TypeError.new(ret_err + ret.class.name)
          exception.set_backtrace(caller)
          action.call(exception)
        end

        ret
      end
    end

    def instance_3pos(name, (ta, tb, tc, tr), original, action)
      argstring = [ta, tb, tc].join(',')
      err       = "#{name} has signature of #{argstring} but received "
      ret_err   = "#{name} should return #{tr.name} but returned "

      define_method name do |a, b, c|
        unless a.is_a?(ta) && b.is_a?(tb) && c.is_a?(tc)
          exception = TypeError.new(err + a.class.name)
          exception.set_backtrace(caller)
          action.call(exception)
        end

        ret = original.bind(self).call(a, b, c)

        unless ret.is_a?(tr)
          exception = TypeError.new(ret_err + ret.class.name)
          exception.set_backtrace(caller)
          action.call(exception)
        end

        ret
      end
    end

    def instance_4pos(name, (ta, tb, tc, td, tr), original, action)
      argstring = [ta, tb, tc, td].join(',')
      err       = "#{name} has signature of #{argstring} but received "
      ret_err   = "#{name} should return #{tr.name} but returned "

      define_method name do |a, b, c, d|
        unless a.is_a?(ta) && b.is_a?(tb) && c.is_a?(tc) && d.is_a?(td)
          exception = TypeError.new(err + a.class.name)
          exception.set_backtrace(caller)
          action.call(exception)
        end

        ret = original.bind(self).call(a, b, c, d)

        unless ret.is_a?(tr)
          exception = TypeError.new(ret_err + ret.class.name)
          exception.set_backtrace(caller)
          action.call(exception)
        end

        ret
      end
    end

    def instance_5pos(name, (ta, tb, tc, td, te, tr), original, action)
      argstring = [ta, tb, tc, td, te].join(',')
      err       = "#{name} has signature of #{argstring} but received "
      ret_err   = "#{name} should return #{tr.name} but returned "

      define_method name do |a, b, c, d, e|
        unless a.is_a?(ta) && b.is_a?(tb) && c.is_a?(tc) &&
               d.is_a?(td) && e.is_a?(te)
          exception = TypeError.new(err + a.class.name)
          exception.set_backtrace(caller)
          action.call(exception)
        end

        ret = original.bind(self).call(a, b, c, d, e)

        unless ret.is_a?(tr)
          exception = TypeError.new(ret_err + ret.class.name)
          exception.set_backtrace(caller)
          action.call(exception)
        end

        ret
      end
    end

    def instance_6pos(name, (ta, tb, tc, td, te, tf, tr), original, action)
      argstring = [ta, tb, tc, td, te, tf].join(',')
      err       = "#{name} has signature of #{argstring} but received "
      ret_err   = "#{name} should return #{tr.name} but returned "

      define_method name do |a, b, c, d, e, f|
        unless a.is_a?(ta) && b.is_a?(tb) && c.is_a?(tc) &&
               d.is_a?(td) && e.is_a?(te) && f.is_a?(tf)
          exception = TypeError.new(err + a.class.name)
          exception.set_backtrace(caller)
          action.call(exception)
        end

        ret = original.bind(self).call(a, b, c, d, e, f)

        unless ret.is_a?(tr)
          exception = TypeError.new(ret_err + ret.class.name)
          exception.set_backtrace(caller)
          action.call(exception)
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
            exception.set_backtrace(caller)
            raise exception
          end
        end

        ret = original.bind(self).call(*args)

        unless ret.is_a?(ret_sig)
          exception = TypeError.new(ret_err + ret.class.name)
          exception.set_backtrace(caller)
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
