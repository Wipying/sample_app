module SessionsHelper
	def sign_in(user)
		new_remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = {value: new_remember_token, expires: 20.years.from_now.utc }
		user.update_attribute(:remember_token, User.hash(new_remember_token))
		self.current_user = user
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		remember_token = User.hash(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		current_user.update_attribute(:remember_token, User.hash(User.new_remember_token))
		cookies.delete(:remember_token)
		self.current_user = nil
	end
end
