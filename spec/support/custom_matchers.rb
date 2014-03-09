module CustomMatchers
  extend RSpec::Matchers::DSL

  matcher :have_error_message do |message|
    match do |page|
      expect(page).to have_selector('div.alert.alert-error', text: message)
    end

    failure_message_for_should do
      "expected page to have error message \"#{message}\""
    end
  end

  matcher :have_sunny_message do |message|
    match do |page|
      expect(page).to have_selector('div.alert.alert-success', text: message)
    end

    failure_message_for_should do
      "expected page to have sunny message \"#{message}\""
    end
  end
end
