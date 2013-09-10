Feature: Create and maintain address

  @user_with_basic_info
  Scenario: Initial Address Creation
    Given I have step one of the signup complete (basic user info)
    And I am on the new address page
    When I fill in the following fields for 'address':
    | address_line1   | city        | state | zip   |
    | 22 Weatherby ct.| Petaluma    | CA    | 94954 |
    And I click the 'Continue to Paypal' button
    Then I should have an address attatched to my account
