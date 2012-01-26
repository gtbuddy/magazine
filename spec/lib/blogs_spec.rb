require "spec_helper"

describe Magazine::Blogs do
  
  it "should be included in ActiveRecord::Base" do
    ActiveRecord::Base.included_modules.should include(Magazine::Blogs)
  end
  
  describe :blogs do
    it "should be a class macro to AR Base" do
      ActiveRecord::Base.methods.should include(:blogs)
    end
    
    
    it "should build a hm assosciation on the model it's called in" do
      lambda { User.new.articles }.should_not raise_exception(NoMethodError)
      User.new.articles.should be_an(Array)
    end
        
  end

  
end