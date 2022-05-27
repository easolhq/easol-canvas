describe Canvas::FetchCustomTypes do
  include ExampleDirectoryHelper

  describe ".call" do
    it "returns all the custom types as ruby hashes" do
      copy_example_directory("alchemist")
      expect(Canvas::FetchCustomTypes.call).to match_array(
        [
          {
            "key" => "image_text_card",
            "name" => "Image and Text Card",
            "attributes" => [
              {
                "name" => "title",
                "label" => "Title",
                "type" => "string"
              },
              {
                "name" => "text",
                "label" => "Text",
                "type" => "text"
              },
              {
                "name" => "image",
                "label" => "Image",
                "type" => "image"
              }
            ]
          },
          {
            "key" => "faq",
            "name" => "Faq",
            "attributes" => [
              {
                "name" => "question",
                "label" => "Question",
                "type" => "string"
              },
              {
                "name" => "answer",
                "label" => "Answer",
                "type" => "text"
              }
            ]
          }
        ]
      )
    end

    context "when theme contains invalid custom types" do
      before do
        copy_example_directory("vagabond")
      end

      it "skips the invalid custom types" do
        expect(Canvas::FetchCustomTypes.call).to match_array(
          [
            {
              "key" => "faq",
              "name" => "Faq",
              "attributes" => [
                {
                  "name" => "question",
                  "label" => "Question",
                  "type" => "string"
                },
                {
                  "name" => "answer",
                  "label" => "Answer",
                  "type" => "text"
                }
              ]
            }
          ]
        )
      end
    end
  end
end
