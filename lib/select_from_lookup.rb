# SelectFromLookup
# ActionView::Helpers::FormOptionsHelper
module SelectFromLookup
  # f.lookup_select
  # f.lookup_select(:status, :name, {}, {},:style => "color:red")
  class ActionView::Helpers::FormBuilder
    def lookup_select(method, option_label, options = {}, html_options = {})      
      # option_label is used for <OPTION> option_label </OPTION>
      
      association = Association.new self.object, method, option_label
      
      @template.select(@object_name, association.foreign_key, association.choices, options.merge(:object => @object), html_options)
    end
  end
  
  # lookup_select :object, :method
  # lookup_select(@member, :status, {}, {},:style => "color:red")
  def lookup_select( object, method, option_label, options = {}, html_options = {} )
    raise(NameError, "#{object} is not an ActiveRecord::Base object") unless is_active_record?( object.class )   
    
    association = Association.new object, method, option_label
   
    #options[:selected] ||= association.foreign_key
    ActionView::Helpers::InstanceTag.new(object.class.to_s.downcase, association.foreign_key, self, 
      nil, options.delete(:object)).to_select_tag(association.choices, options, html_options)
  end
  
  # a recursive method to test a Class to see if it's ActiveRecord
  def is_active_record? object
    return false if object.nil?
    (object == ActiveRecord::Base) || is_active_record?( object.superclass )
  end
  
  class Association
    attr_reader :foreign_key, :choices
    def initialize object, method, option_label
      object_class           = object.class
      association            = object_class.reflect_on_association method

      raise(NameError, "Fail to generate lookup: #{object_class} does not belong to #{method}") unless association 

      association_class_name = association.options[:class_name] || association.name
      association_class      = association_class_name.to_s.camelize.constantize
      @foreign_key           = association.options[:foreign_key] || association.name.to_s + '_id'
      @choices               = association_class.find(:all).collect{|x| [x.send(option_label), x.id]}
    end
  end
end
