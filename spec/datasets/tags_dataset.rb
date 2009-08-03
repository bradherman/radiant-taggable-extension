require 'digest/sha1'

class TagsDataset < Dataset::Base
  uses :pages
  
  def load
    create_tag "Colourless"
    create_tag "Ideas"
    create_tag "Sleep"
    create_tag "Furiously"
    
    apply_tag :colourless, pages(:first)
    apply_tag :ideas, pages(:first), pages(:another), pages(:grandchild)
    apply_tag :sleep, pages(:first)
    apply_tag :furiously, pages(:first)
  end
  
  helpers do
    def create_tag(title, attributes={})
      attributes = tag_attributes(attributes.update(:title => title))
      tag = create_model Tag, title.symbolize, attributes
    end
    
    def tag_attributes(attributes={})
      title = attributes[:name] || "Tag"
      attributes = { 
        :title => title
      }.merge(attributes)
      attributes
    end
        
    def apply_tag(tag, *items)
      tag = tag.is_a?(Tag) ? tag : tags(tag)
      items.each { |i| i.attached_tags << tag }
    end
    
  end
 
end