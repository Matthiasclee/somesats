require "application_system_test_case"

class GiftCardsTest < ApplicationSystemTestCase
  setup do
    @gift_card = gift_cards(:one)
  end

  test "visiting the index" do
    visit gift_cards_url
    assert_selector "h1", text: "Gift cards"
  end

  test "should create gift card" do
    visit gift_cards_url
    click_on "New gift card"

    fill_in "Id", with: @gift_card.id
    fill_in "Sats", with: @gift_card.sats
    click_on "Create Gift card"

    assert_text "Gift card was successfully created"
    click_on "Back"
  end

  test "should update Gift card" do
    visit gift_card_url(@gift_card)
    click_on "Edit this gift card", match: :first

    fill_in "Id", with: @gift_card.id
    fill_in "Sats", with: @gift_card.sats
    click_on "Update Gift card"

    assert_text "Gift card was successfully updated"
    click_on "Back"
  end

  test "should destroy Gift card" do
    visit gift_card_url(@gift_card)
    click_on "Destroy this gift card", match: :first

    assert_text "Gift card was successfully destroyed"
  end
end
