require 'rubygems'
require File.dirname(__FILE__) + '/../lib/rdf/threadsafe'
require 'rdf/ntriples'

describe "Threadsafe RDF" do
  it "should not throw NameErrors when Values are created in threads" do
    graphs = []
    lambda {
      threads = []
      (0..9).each do |i|
        threads << Thread.new {
          graph = RDF::Graph.new
          u = RDF::URI.intern("http://example.org/#{i}")
          p = RDF::URI.intern("http://example.org/vocab/#{i}")
          n = RDF::Node.new("_:#{i}")
          n.is_a?(RDF::Term)
          graph << RDF::Statement.new(u,p,n)
          graph << [u,p,RDF::Literal.new(i)]
          graph << [u,p,RDF::Literal.new("#{i}", :language=>:en)]          
          graph << [u,p,RDF::Literal.new(DateTime.now)]       
          graph << [u,p,RDF::Literal.new(Date.today)]                              
          graph << [u,p, RDF::Literal.new(true)]
          graph << [u,p, RDF::Literal.new(12.21)]
          graphs << graph
        }        
      end
      threads.each {|t| t.join}
    }.should_not raise_exception(NameError)
    graphs.length.should ==(10)
  end
  
  it "should not throw NameErrors when serializers are used in threads" do
    outs = []
    lambda {
      threads = []
      (0..9).each do |i|
        threads << Thread.new {
          RDF::Format.each { |klass| klass.name }
          graph = RDF::Graph.new
          RDF::Reader.open(File.dirname(__FILE__) + "/files/test.nt") do |reader|
            reader.each_statement do |statement|
              graph << statement
            end
          end
          outs << RDF::Writer.for(:ntriples).buffer do |writer|
            graph.each_statement do |statement|
              writer << statement
            end
          end
        }
      end
      threads.each {|t| t.join }    
    }.should_not raise_exception(NameError)
    outs.length.should ==(10)
    outs.each do |out|
      out.should be_kind_of(String)
    end
  end
  
  it "should not throw NameErrors when Repositories are used in threads" do
    repos = []
    lambda {
      threads = []
      (0..9).each do |i|
        threads << Thread.new {
          repository = RDF::Repository.new
          repository.readable?
          repository.writable?
          repository.persistent?
          repository.transient?
          repository.empty?
          stmt = RDF::Statement.new(RDF::URI.new("http://example.org/#{i}"), RDF.type, RDF::FOAF.Agent)
          repository.insert(stmt)
          repository.has_statement?(stmt)
          RDF::Transaction.execute(repository) do |tx|
            tx.delete(stmt)
            tx.insert [stmt.subject, stmt.predicate, RDF::FOAF.Person]
          end
          repos << repository
        }  
      end
      threads.each {|t| t.join }    
    }.should_not raise_exception        
    repos.length.should ==(10)
  end
  
  it "should not throw NameErrors when Queries are used in threads" do
    lambda {
      threads = []
      graph = RDF::Graph.new
      (0..9).each do |i|
        graph << [RDF::URI.new("http://example.org/#{i}"), RDF.type, RDF::FOAF.Person]
        graph << [RDF::URI.new("http://example.org/#{i}"), RDF::FOAF.name, RDF::Literal.new("Example #{i}")]                    
        graph << [RDF::URI.new("http://example.org/#{i}"), RDF::FOAF.mbox, RDF::Literal.new("example.#{i}@example.org")]        
        threads << Thread.new {   
          query = RDF::Query.new do |q|
            q.pattern [:person, RDF.type,  RDF::FOAF.Person]
            q.pattern [:person, RDF::FOAF.name, :name]
            q.pattern [:person, RDF::FOAF.mbox, :email]            
          end
          query.execute(graph).each do |solution|
            solution.is_a?(RDF::Query::Solution).should ==(true)
          end          
        }
      end
      threads.each {|t| t.join }      
    }.should_not raise_exception(NameError)
  end
  
  it "should not throw NameErrors when Vocabularies are used in threads" do
    lambda {
      threads = []
      (0..9).each do |i|
        threads << Thread.new {
          RDF.type.is_a?(RDF::URI)
          ["CC", "CERT", "DC", "DC11", "DOAP", "EXIF", "FOAF", "GEO", "HTTP", "OWL", "RDFS",
             "RSA", "RSS", "SIOC", "SKOS", "WOT", "XHTML", "XSD"].each do |v|
            RDF.const_get(v).send(:foo).should be_kind_of(RDF::URI)
          end
        }
      end
      threads.each {|t| t.join }      
    }.should_not raise_exception(NameError)
  end
end