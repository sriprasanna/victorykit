class Signature < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :reference_type, :referer, :referring_url, :browser_name
  belongs_to :petition
  belongs_to :member
  belongs_to :referer, :class_name => 'Member', :foreign_key => 'referer_id'
  has_one :sent_email
  validates_presence_of :first_name, :last_name
  validates :email, :presence => true, :email => true

  module ReferenceType
    FACEBOOK_LIKE = 'facebook_like'
    FACEBOOK_SHARE = 'facebook_share'
    FACEBOOK_POPUP = 'facebook_popup'
    FACEBOOK_WALL = 'facebook_wall'
    FACEBOOK_REQUEST = 'facebook_request'
    TWITTER = 'twitter'
    EMAIL = 'email'
    SHARED_LINK = 'shared_link'
    FORWARDED_NOTIFICATION = 'forwarded_notification'
  end

  REFERENCE_TYPES = [ 
    ReferenceType::FACEBOOK_LIKE, 
    ReferenceType::FACEBOOK_SHARE, 
    ReferenceType::FACEBOOK_POPUP, 
    ReferenceType::FACEBOOK_WALL, 
    ReferenceType::FACEBOOK_REQUEST, 
    ReferenceType::TWITTER, 
    ReferenceType::EMAIL, 
    ReferenceType::FORWARDED_NOTIFICATION, 
    ReferenceType::SHARED_LINK,
    nil ] # <= why?

  validates :reference_type, :inclusion => {
    :in => REFERENCE_TYPES, 
    :message => "%{value} is not a valid reference_type"
  }

  before_save :truncate_user_agent

  def full_name
    "#{self.first_name} #{self.last_name}".strip
  end

  def full_name=val
    name_parts = val.split(" ")
    if name_parts.length == 1
      self.first_name = val
    else
      self.last_name = name_parts.pop
      self.first_name= name_parts.join(" ")
    end
  end

  def truncate_user_agent
    self.user_agent = self.user_agent[0..254]
  end

  def prepopulate(member)
    self.tap do |s|
      s.full_name = member.try(:name)
      s.email = member.try(:email)
    end
  end

end
