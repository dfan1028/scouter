class Product < ActiveRecord::Base

  after_initialize :set_platform_default

  validates :ext_id, presence: true

  private

  def set_platform_default
    self.platform = :amazon
  end
end
