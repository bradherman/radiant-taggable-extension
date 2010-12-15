class ImportKeywords < ActiveRecord::Migration
  def self.up
    if !Page.all == nil
      Page.all.each do |page|
        page.tags_from_keywords
      end
    end
  end

  def self.down

  end
end
