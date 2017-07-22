module FeaturesHelper
  DELAY = Selenium::WebDriver::Wait.new(timeout: 50)

  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
    DELAY.until { has_content?('Log out') }
  end
end
