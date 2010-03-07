# SelectFromLookup
#ActionView::Helpers::FormOptionsHelper

module SelectFromLookup
  # lookup_select :object, :method
  # lookup_select(@member, :status, {}, {},:style => "color:red")
  def lookup_select( object, method, choices = {}, options = {}, html_options = {} )
    raise(NameError, "#{object} is not an ActiveRecord::Base object") unless is_active_record?( object.class )    
    belongs_to_object     = object.send(method.gsub(/_id$/,'')) rescue raise(NameError, "Fail to generate lookup: #{object.class} does not belong to #{method.gsub(/_id$/,'')}, #{method.gsub(/_id$/,'')} is probably mispelled?")
    if belongs_to_object.nil? and object.respond_to? method.gsub(/_id$/,'')
      choices               = object.send("build_#{method.gsub(/_id$/,'')}").class.find(:all, :order => "name asc").collect{|x| [x.name, x.id]}
    else
      choices               = belongs_to_object.class.find(:all, :order => "name asc").collect{|x| [x.name, x.id]}
      options[:selected]  ||= object.send("#{method.gsub(/_id$/,'')}_id")
    end    
    ActionView::Helpers::InstanceTag.new(object.class.to_s.downcase, method, self, nil, options.delete(:object)).to_select_tag(choices, options, html_options)
  end
  
  class ActionView::Helpers::FormBuilder
    # f.lookup_select
    # f.lookup_select(@member, :status, {}, {},:style => "color:red")
    def lookup_select(method, choices = {}, options = {}, html_options = {})      
      choices    = {}
      the_object = self.object
      
      if the_object.nil? and the_object.respond_to? method
        choices               = the_object.send("build_#{method.gsub(/_id$/,'')}").class.find(:all, :order => "name asc").collect{|x| [x.name, x.id]}
      else
        choices               = the_object.send(method.gsub(/_id$/,'')).class.find(:all, :order => "name asc").collect{|x| [x.name, x.id]}
        options[:selected] ||=  the_object.send("#{method.gsub(/_id$/,'')}_id")
      end
      @template.select(@object_name, method, choices, options.merge(:object => @object), html_options)
    end
  end

  # a recursive method to test a Class to see if it's ActiveRecord
  def is_active_record? object
    return false if object.nil?
    (object == ActiveRecord::Base) || is_active_record?( object.superclass )
  end
end
