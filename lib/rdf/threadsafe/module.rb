class Module
  ##
  # Take Module#autoload, unbind it and rebind it as #regular_autoload
  #
  define_method(:regular_autoload, self.instance_method(:autoload).unbind)
  
  ##
  # For any autoload call from a caller in the RDF module namespace, use require instead.
  # All other callers use the normal autoload
  #
  def rdf_autoload(sym, path)
    if self.name =~ /^RDF(\:\:|$)/
      require path
    else
      regular_autoload(sym, path)
    end
  end
  
  ##
  # Alias rdf_autoload to autoload
  #
  alias_method :autoload, :rdf_autoload
end