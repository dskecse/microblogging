module AuthenticationHelpers
  def valid_signin(user, options = {})
    if options[:no_capybara]
      # Sign in when not using Capybara
      remember_token = User.new_remember_token
      cookies.permanent[:remember_token] = remember_token
      user.update_attribute(:remember_token, User.hash(remember_token))
    else
      visit signin_path
      fill_in 'Email',    with: user.email.upcase
      fill_in 'Password', with: user.password
      click_button 'Sign in'
    end
  end

  def fill_form_using(email)
    fill_in 'Name',         with: 'Example User'
    fill_in 'Email',        with: email
    fill_in 'Password',     with: 'foobar'
    fill_in 'Confirmation', with: 'foobar'
  end
end
