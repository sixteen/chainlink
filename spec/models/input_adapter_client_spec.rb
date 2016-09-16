describe InputAdapterClient, type: :model do
  let(:assignment) { factory_create :assignment }
  let(:validator) { assignment.adapter }
  let(:client) { InputAdapterClient.new(validator) }

  describe "#create_assignment" do
    it "sends a post message to the validator client" do
      expect(InputAdapterClient).to receive(:post)
        .with("#{validator.url}/assignments", {
          basic_auth: {
            password: validator.password,
            username: validator.username,
          },
          body: {
            data: assignment.parameters,
            end_at: assignment.end_at.to_i.to_s,
            xid: assignment.xid,
          },
          headers: {}
        }).and_return(http_response body: {}.to_json)

      client.start_assignment assignment
    end
  end

  describe "#assignment_snapshot" do
    let(:snapshot) { factory_create :assignment_snapshot }
    let(:assignment) { snapshot.assignment }
    let(:expected_response) { hashie({a: 1}) }

    it "sends a post message to the validator client" do
      expect(InputAdapterClient).to receive(:post)
        .with("#{validator.url}/assignments/#{assignment.xid}/snapshots", {
          basic_auth: {
            password: validator.password,
            username: validator.username,
          },
          body: {
            xid: snapshot.xid,
          },
          headers: {}
        }).and_return(http_response body: expected_response.to_json)

      response = client.assignment_snapshot snapshot

      expect(response).to eq(expected_response)
    end
  end

  describe "#stop_assignment" do
    let(:expected_response) { hashie({a: 1}) }

    it "sends a post message to the validator client" do
      expect(InputAdapterClient).to receive(:delete)
        .with("#{validator.url}/assignments/#{assignment.xid}", {
          basic_auth: {
            password: validator.password,
            username: validator.username,
          },
          body: {},
          headers: {}
        }).and_return(http_response body: expected_response.to_json)

      response = client.stop_assignment assignment

      expect(response).to eq(expected_response)
    end
  end

end