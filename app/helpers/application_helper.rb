module ApplicationHelper
  def avatar_url(user)
    if user.image
      "http://graph.facebook.com/#{user.uid}/picture?type=large"
    else
      gravatar_id = Digest::MD5::hexdigest(user.email).downcase
      "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=identical&s=150"
    end
  end

  def stripe_params_path
    "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_DfVYJRzrdFyhofr8HfAt0rl9ZuSPGiWl&scope=read_write"
    #"https://connect.stripe.com/express/oauth/authorize?response_type=code&client_id=ca_DfVYJRzrdFyhofr8HfAt0rl9ZuSPGiWl&scope=read_write"
  end
end
