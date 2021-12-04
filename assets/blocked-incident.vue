<template>
  <tr>
   <td>
     <incident-link v-bind:incident="incident"></incident-link>
    </td>
    <td>
      <div v-if="Object.keys(incident_results).length + Object.keys(update_results).length === 0">
         No data yet
      </div>
      <ul v-else class="summary-list">
        <li is="blocked-incident-inc-result"
            v-for="(result, group_id) in incident_results"
            v-bind:key="group_id"
            v-bind:group_id="group_id"
            v-bind:result="result"
           >
        </li>
        <li is="blocked-incident-upd-result"
           v-for="(result, group_id) in update_results"
           v-bind:key="group_id"
           v-bind:group_id="group_id"
           v-bind:result="result"
           >
        </li>
      </ul>
    </td>
  </tr>
</template>

<script>
module.exports = {
  props: ['incident', 'incident_results', 'update_results']
};

</script>