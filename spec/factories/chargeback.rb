FactoryBot.define do

  factory :chargeback, class: Riskified::Entities::ChargebackMessage do
    id {rand(111..999)}
    chargeback_details {
      Riskified::Entities::ChargebackDetails.new(
        id: nil,
        chargeback_at: "2019-10-07",
        chargeback_currency: "EUR",
        chargeback_amount: 100,
        reason_code: "no_reason",
        type: "cb",
        gateway: "credit_card",
        reason_description: "no_reason",
        mid: nil,
        arn: nil,
        credit_card_company: "visa",
        respond_by: "2020-05-01",
        card_issuer: "Testing Test"
      )
    }
    dispute_details {
      Riskified::Entities::DisputeDetails.new(
        id: nil,
        case_id: "11",
        status: "status",
        dispute_type: "won"
      )
    }
  end
end