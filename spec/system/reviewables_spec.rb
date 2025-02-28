# frozen_string_literal: true

describe "Reviewables", type: :system do
  let(:review_page) { PageObjects::Pages::Review.new }
  fab!(:admin) { Fabricate(:admin) }
  fab!(:theme) { Fabricate(:theme) }
  fab!(:long_post) { Fabricate(:post_with_very_long_raw_content) }

  before { sign_in(admin) }

  describe "when there is a flagged post reviewable with a long post" do
    fab!(:long_reviewable) { Fabricate(:reviewable_flagged_post, target: long_post) }

    it "should show a button to expand/collapse the post content" do
      visit("/review")
      expect(review_page).to have_post_body_collapsed
      expect(review_page).to have_post_body_toggle
      review_page.click_post_body_toggle
      expect(review_page).to have_no_post_body_collapsed
      review_page.click_post_body_toggle
      expect(review_page).to have_post_body_collapsed
    end
  end

  describe "when there is a flagged post reviewable with a short post" do
    fab!(:short_reviewable) { Fabricate(:reviewable_flagged_post) }

    it "should not show a button to expand/collapse the post content" do
      visit("/review")
      expect(review_page).to have_no_post_body_collapsed
      expect(review_page).to have_no_post_body_toggle
    end
  end

  describe "when there is a queued post reviewable with a short post" do
    fab!(:short_queued_reviewable) { Fabricate(:reviewable_queued_post) }

    it "should not show a button to expand/collapse the post content" do
      visit("/review")
      expect(review_page).to have_no_post_body_collapsed
      expect(review_page).to have_no_post_body_toggle
    end
  end

  describe "when there is a queued post reviewable with a long post" do
    fab!(:long_queued_reviewable) { Fabricate(:reviewable_queued_long_post) }

    it "should show a button to expand/collapse the post content" do
      visit("/review")
      expect(review_page).to have_post_body_collapsed
      expect(review_page).to have_post_body_toggle
      review_page.click_post_body_toggle
      expect(review_page).to have_no_post_body_collapsed
      review_page.click_post_body_toggle
      expect(review_page).to have_post_body_collapsed
    end
  end

  context "when performing a review action from the show route" do
    context "with a ReviewableQueuedPost" do
      fab!(:queued_post_reviewable) { Fabricate(:reviewable_queued_post) }

      it "delete_user does not delete reviewable" do
        review_page.visit_reviewable(queued_post_reviewable)

        expect(queued_post_reviewable).to be_pending
        expect(queued_post_reviewable.target_created_by).to be_present
        expect(review_page).to have_reviewable_action_dropdown
        expect(review_page).to have_reviewable_with_pending_status(queued_post_reviewable)

        review_page.select_bundled_action(queued_post_reviewable, "delete_user")

        expect(review_page).to have_no_error_dialog_visible
        expect(review_page).to have_reviewable_with_rejected_status(queued_post_reviewable)
        expect(review_page).to have_no_reviewable_action_dropdown
        expect(queued_post_reviewable.reload).to be_rejected
        expect(queued_post_reviewable.target_created_by).to be_nil
      end

      it "allows revising and rejecting to send a PM to the user" do
        revise_modal = PageObjects::Modals::Base.new

        review_page.visit_reviewable(queued_post_reviewable)

        expect(queued_post_reviewable).to be_pending
        expect(queued_post_reviewable.target_created_by).to be_present

        review_page.select_action(queued_post_reviewable, "revise_and_reject_post")

        expect(revise_modal).to be_open

        reason_dropdown =
          PageObjects::Components::SelectKit.new(".revise-and-reject-reviewable__reason")
        reason_dropdown.select_row_by_value(SiteSetting.reviewable_revision_reasons_map.first)
        find(".revise-and-reject-reviewable__feedback").fill_in(with: "This is a test")
        revise_modal.click_primary_button

        expect(review_page).to have_reviewable_with_rejected_status(queued_post_reviewable)
        expect(queued_post_reviewable.reload).to be_rejected
        expect(Topic.where(archetype: Archetype.private_message).last.title).to eq(
          I18n.t(
            "system_messages.reviewable_queued_post_revise_and_reject.subject_template",
            topic_title: queued_post_reviewable.topic.title,
          ),
        )
      end

      it "allows selecting a custom reason for revise and reject" do
        revise_modal = PageObjects::Modals::Base.new

        review_page.visit_reviewable(queued_post_reviewable)

        expect(queued_post_reviewable).to be_pending
        expect(queued_post_reviewable.target_created_by).to be_present

        review_page.select_action(queued_post_reviewable, "revise_and_reject_post")
        expect(revise_modal).to be_open

        reason_dropdown =
          PageObjects::Components::SelectKit.new(".revise-and-reject-reviewable__reason")
        reason_dropdown.select_row_by_value("other_reason")
        find(".revise-and-reject-reviewable__custom-reason").fill_in(with: "I felt like it")
        find(".revise-and-reject-reviewable__feedback").fill_in(with: "This is a test")
        revise_modal.click_primary_button

        expect(review_page).to have_reviewable_with_rejected_status(queued_post_reviewable)
      end
    end
  end
end
