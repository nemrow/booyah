Feature: User Signup

  Scenario: Create user | step 1 (basic info) sucessfully
    Given I am not a user
    When I visit the homepage
    And I fill in the following fields for 'user':
      | email             | name          | cell        | password  |
      | nemrowj@gmail.com | Jordan Nemrow | 7078496085  | password  |
    And I click the 'Start Printing!' button
    Then the page should show 'Hello Jordan, you're almost ready to start printing!'

    Scenario: Create user | step 1 (basic info) without correct info 
    Given I am not a user
    When I visit the homepage
    And I fill in the following fields for 'user':
      | email             | name          | password  |
      | nemrowj@gmail.com | Jordan Nemrow | password  |
    And I click the 'Start Printing!' button
    Then the page should show 'We are unable to create an account with the info you provided. Please try again.'
    