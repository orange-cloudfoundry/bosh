require_relative '../../spec_helper'

describe 'health_monitor with legacy manifest', type: :integration, hm: true do
  context 'if fix_stateful_nodes director option is not set' do
    with_reset_sandbox_before_each(director_fix_stateful_nodes: false)
    before { current_sandbox.health_monitor_process.start }
    after { current_sandbox.health_monitor_process.stop }

    it 'resurrects stateless nodes' do
      deploy_from_scratch({legacy: true, manifest_hash: Bosh::Spec::Deployments.legacy_manifest})

      original_vm = director.instance('foobar', '0', deployment_name: 'simple')
      original_vm.kill_agent
      resurrected_vm = director.wait_for_vm('foobar', '0', 300, deployment_name: 'simple')
      expect(resurrected_vm.vm_cid).to_not eq(original_vm.vm_cid)
    end
  end
end