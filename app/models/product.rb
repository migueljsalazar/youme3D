class Product < ActiveRecord::Base
  has_many :campaigns, dependent: :destroy
  belongs_to :designer
  has_attached_file :object, :s3_protocol => :https
  validates_attachment_content_type :object, :content_type=>['application/octet-stream']
  has_attached_file :image, :s3_protocol => :https
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates :x, :y, :z, numericality: { only_integer: true }, :presence => true
  validates :name, :presence => true, :length => { :in => 2..20 }

  def to_s
    "#{self.name.downcase}"
  end

  # w/o color $.68 per cm^3
  # w/ color $2.00 per cm^3
  def basecosteq
    @basecost = ((x.to_f/10) * (y.to_f/10) * (z.to_f/10)) * 0.68
  end

  def formatted_base_cost
    price_in_dollars = basecosteq
    format("%.2f", price_in_dollars)
  end

end
