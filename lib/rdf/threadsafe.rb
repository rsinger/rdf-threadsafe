require File.dirname(__FILE__) + '/threadsafe/module'
module RDF
  ##
  # Alias for `RDF::Resource.new`.
  #
  # @return [RDF::Resource]
  def self.Resource(*args, &block)
    Resource.new(*args, &block)
  end
  
  ##
  # Alias for `RDF::Node.new`.
  #
  # @return [RDF::Node]
  def self.Node(*args, &block)
    Node.new(*args, &block)
  end
  
  ##
  # Alias for `RDF::URI.new`.
  #
  # @overload URI(uri)
  #   @param  [URI, String, #to_s]    uri
  #
  # @overload URI(options = {})
  #   @param  [Hash{Symbol => Object} options
  #
  # @return [RDF::URI]
  def self.URI(*args, &block)
    case uri = args.first
      when RDF::URI then uri
      else case
        when uri.respond_to?(:to_uri) then uri.to_uri
        else URI.new(*args, &block)
      end
    end
  end
  
  ##
  # Alias for `RDF::Literal.new`.
  #
  # @return [RDF::Literal]
  def self.Literal(*args, &block)
    case literal = args.first
      when RDF::Literal then literal
      else Literal.new(*args, &block)
    end
  end
  
  ##
  # Alias for `RDF::Graph.new`.
  #
  # @return [RDF::Graph]
  def self.Graph(*args, &block)
    Graph.new(*args, &block)
  end
  
  ##
  # Alias for `RDF::Statement.new`.
  #
  # @return [RDF::Statement]
  def self.Statement(*args, &block)
    Statement.new(*args, &block)
  end
  
  ##
  # Alias for `RDF::Vocabulary.create`.
  #
  # @param  [String] uri
  # @return [Class]
  def self.Vocabulary(uri)
    Vocabulary.create(uri)
  end
  
  ##
  # @return [URI]
  def self.type
    self[:type]
  end
  
  ##
  # @return [#to_s] property
  # @return [URI]
  def self.[](property)
    RDF::URI.intern([to_uri.to_s, property.to_s].join)
  end
  
  ##
  # @param  [Symbol] property
  # @return [URI]
  # @raise  [NoMethodError]
  def self.method_missing(property, *args, &block)
    if args.empty?
      self[property]
    else
      super
    end
  end
  
  ##
  # @return [URI]
  def self.to_rdf
    to_uri
  end
  
  ##
  # @return [URI]
  def self.to_uri
    RDF::URI.intern("http://www.w3.org/1999/02/22-rdf-syntax-ns#")
  end
  
  class << self
    # For compatibility with `RDF::Vocabulary.__name__`:
    alias_method :__name__, :name
  end
  
  # Load order matters, this needs to be tweaked if JRuby throws NameErrors.
  
  require 'rdf/util'
  require 'rdf/util/cache'  
  require 'rdf/mixin/readable'
  require 'rdf/mixin/writable'  
  require 'rdf/mixin/countable'    
  require 'rdf/mixin/enumerable'  
  require 'rdf/mixin/queryable'        
  require 'rdf/mixin/mutable'    
  require 'rdf/mixin/durable'  
  require 'rdf/vocab.rb'
  
  require 'rdf/model/value'  
  require 'rdf/model/term'  
  require 'rdf/vocab/xsd'
  require 'rdf/vocab/foaf'
  require 'rdf/model/resource' 
  require 'rdf/model/uri'
  require 'rdf/model/literal/boolean'
  require 'rdf/model/literal/numeric'  
  require 'rdf/model/literal/decimal'    
  require 'rdf/model/statement'
  require 'rdf/repository'
  require 'rdf/query'
  require 'rdf/query/pattern'     
end

require 'rdf'
require File.dirname(__FILE__) + '/threadsafe/util/cache'