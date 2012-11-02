module Rack
  class BodyProxy
    def initialize(body, &block)
      @body, @block, @closed = body, block, false
    end

    def respond_to?(*args)
      return false if args.first.to_s =~ /^to_ary$/
      super or @body.respond_to?(*args)
    end

    def close
      return if @closed
      @closed = true
      @body.close if @body.respond_to? :close
      @block.call
    end

    def closed?
      @closed
    end

    def method_missing(*args, &block)
      super if args.first.to_s =~ /^to_ary$/
      @body.__send__(*args, &block)
    end
  end
end
