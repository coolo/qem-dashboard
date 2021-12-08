<template>
  <tr v-if="Object.keys(filteredIncidentResults).length + Object.keys(filteredUpdateResults).length > 0">
    <td>
      <IncidentLink :incident="incident" />
    </td>
    <td>
      <ul class="summary-list">
        <BlockedIncidentIncResult
          v-for="(result, groupId) in filteredIncidentResults"
          :key="groupId"
          :group-id="groupId"
          :result="result"
        />
        <BlockedIncidentUpdResult
          v-for="(result, groupId) in filteredUpdateResults"
          :key="groupId"
          :group-id="groupId"
          :result="result"
          :group-flavors="groupFlavors"
        />
      </ul>
    </td>
  </tr>
</template>

<script>
import BlockedIncidentIncResult from './BlockedIncidentIncResult.vue';
import BlockedIncidentUpdResult from './BlockedIncidentUpdResult.vue';
import IncidentLink from './IncidentLink.vue';

export default {
  name: 'BlockedIncident',
  components: {
    IncidentLink,
    BlockedIncidentIncResult,
    BlockedIncidentUpdResult
  },
  props: {
    incident: {type: Object, required: true},
    incidentResults: {type: Object, required: true},
    updateResults: {type: Object, required: true},
    groupFlavors: {type: Boolean, required: true},
    resultSelected: {type: String, required: true},
    channelSelected: {type: String, required: true}
  },
  computed: {
    filteredIncidentResults() {
      if (this.resultSelected === 'only-agg') {
        return {};
      }
      const results = {};
      for (const [key, value] of Object.entries(this.incidentResults)) {
        if (this.channelSelected !== 'all' && value.name !== this.channelSelected) continue;
        results[key] = value;
      }
      return results;
    },
    filteredUpdateResults() {
      const results = {};
      if (this.resultSelected === 'only-inc') {
        return results;
      }
      for (const [key, value] of Object.entries(this.updateResults)) {
        if (this.channelSelected !== 'all' && value.name !== this.channelSelected) continue;
        if (this.groupFlavors) {
          const {flavor} = value.linkinfo;
          const {version} = value.linkinfo;
          const {groupid} = value.linkinfo;
          const newkey = `${groupid}:${version}`;
          if (!(newkey in results)) {
            results[newkey] = {name: value.name, passed: 0, failed: 0, stopped: 0, waiting: 0};
            results[newkey].linkinfo = value.linkinfo;
            results[newkey].linkinfo.flavor = [];
          }
          results[newkey].linkinfo.flavor.push(flavor);
          results[newkey].passed += value.passed || 0;
          results[newkey].stopped += value.stopped || 0;
          results[newkey].waiting += value.waiting || 0;
          results[newkey].failed += value.failed || 0;
        } else {
          results[key] = value;
        }
      }
      return results;
    }
  }
};
</script>
