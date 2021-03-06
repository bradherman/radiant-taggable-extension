class TaggableExtension < Radiant::Extension
  version "1.2.1"
  description "General purpose tagging and retrieval extension: more versatile but less focused than the tags extension"
  url "http://github.com/spanner/radiant-taggable-extension"
  
  extension_config do |config|
    config.gem "repeated_auto_complete"
  end
    
  def activate
    ActiveRecord::Base.send :include, TaggableModel                     # provide is_taggable for everything but don't call it for anything
    Page.send :is_taggable                                              # make pages taggable 
    Page.send :include, TaggablePage                                    # then fake the keywords column and add some inheritance
    Page.send :include, TaggableTags                                    # and the basic radius tags for showing page tags and tag pages
    Admin::PagesController.send :include, TaggableAdminPageController   # tweak the admin interface to make page tags more prominent
    UserActionObserver.instance.send :add_observer!, Tag                # tags get creator-stamped

    unless defined? admin.tag
      Radiant::AdminUI.send :include, TaggableAdminUI
      admin.tag = Radiant::AdminUI.load_default_tag_regions
    end

    if respond_to?(:tab)
      tab("Content") do
        add_item("Tags", "/admin/tags")
      end
    else
      admin.tabs.add "Tags", "/admin/tags", :after => "Layouts", :visibility => [:all]
      if admin.tabs['Tags'].respond_to?(:add_link)
        admin.tabs['Tags'].add_link('tag list', '/admin/tags')
        admin.tabs['Tags'].add_link('tag cloud', '/admin/tags/cloud')
        admin.tabs['Tags'].add_link('new tag', '/admin/tags/new')
      end
    end
    
    #admin.tag.index[:thead].delete('usage_header')
    #admin.tag.index[:tbody].delete('usage_cell')
  end
  
  def deactivate
    admin.tabs.remove "Tags" unless respond_to?(:tab)
  end
end
