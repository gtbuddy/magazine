module Magazine
  class Engine < Rails::Engine
    #isolate_namespace Magazine
    
    initializer "magazine.extend_active_record" do

      if defined?(::ActiveRecord::Base)
        ::ActiveRecord::Base.send(:include, Magazine::Blogs)
        ::ActiveRecord::Base.send(:include, Validators)
      end
      
    end
  end
end
