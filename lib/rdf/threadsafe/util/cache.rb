module RDF; module Util
  class Cache
    ##
    # @param  [Object] value
    # @return [void]
    def define_finalizer!(value)
      # We need to catch when we try to pass a frozen object (namely the RDF vocabulary)
      begin
        ObjectSpace.define_finalizer(value, finalizer) 
      rescue  TypeError
        return
      end
    end
  end
end; end