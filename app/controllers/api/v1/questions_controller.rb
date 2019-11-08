# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < ApiController
      def index
        questions = [
          {
            "id": 1,
            "title": "Quel nom pour la league?",
            "description": "Il faut choisir",
            "endingDate": "2019-11-08T13:45:01+00:00",
            "answers": [
              {
                "id": 1,
                "title": "WAM",
                "description": "dgsdgd"
              },
              {
                "id": 2,
                "title": "IDEA",
                "description": "dgsdgd"
              },
              {
                "id": 3,
                "title": "FAME",
                "description": "dgsdgd"
              }
            ]
          }
        ]

        render body: questions.to_json, content_type: "application/json", status: :ok
      end
    end
  end
end
