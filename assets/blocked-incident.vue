<template>
  <tr>
   <td>
     <incident-link v-bind:incident="incident"></incident-link>
    </td>
    <td>
      <div v-if="Object.keys(incidentResults).length + Object.keys(updateResults).length === 0">
         No data yet
      </div>
      <ul v-else class="summary-list">
        <li is="blocked-incident-inc-result"
            v-for="(result, group_id) in incidentResults"
            v-bind:key="group_id"
            v-bind:groupId="group_id"
            v-bind:result="result"
           >
        </li>
        <li is="blocked-incident-upd-result"
           v-for="(result, groupId) in updateResultsGrouped"
           v-bind:key="groupId"
           v-bind:groupId="groupId"
           v-bind:result="result"
           v-bind:groupFlavors="groupFlavors"
           >
        </li>
      </ul>
    </td>
  </tr>
</template>

<script>
module.exports = {
  props: ['incident', 'incidentResults', 'updateResults', 'groupFlavors'],
  computed: {
    updateResultsGrouped: function() {
      if (!this.groupFlavors)
        return this.updateResults;
      let results = new Object();
      for (const [key, value] of Object.entries(this.updateResults)) {
        let flavor = value.linkinfo.flavor;
        let version = value.linkinfo.version;
        let groupid = value.linkinfo.groupid;
        let newkey = `${groupid}:${version}`;
        if (!(newkey in results)) {
          results[newkey] = {name: value.name, passed: 0, failed: 0, stopped: 0, waiting: 0};
          results[newkey].linkinfo = value.linkinfo;
          results[newkey].linkinfo.flavor = [];
        }
        results[newkey].linkinfo.flavor.push(flavor);
        results[newkey].passed += (value.passed || 0);
        results[newkey].stopped += (value.stopped || 0);
        results[newkey].waiting += (value.waiting || 0);
        results[newkey].failed += (value.failed || 0);
      }
      return results;
    }
  }
};

</script>