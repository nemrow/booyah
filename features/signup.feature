Feature: User Signup

  Scenario: New User Signs Up
    Given I am not a user
    When I visit the homepage
    And I click the 'Sign Up' link
    And I fill in the following fields for 'user':
      | name            | email             | cell        | password  |
      | Jordan Nemrow   | nemrowj@gamil.com | 17078496085 | password  |
    And I fill in the following fields for 'address':
      | address_line_1    | address_line_2  | city      | state | zip   | country |
      | 22 Weatherby ct.  |                 | Petaluma  | CA    | 94954 | US      |
    And I click the 'Join!' button
    Then the page should show 'Welcome to Booyah!'