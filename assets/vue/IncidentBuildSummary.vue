<template>
  <div class="card">
    <div class="card-body text-left">
      <h3 cass="card-title d-flex">Build {{ build }} ({{ number_of_passed }} passed)</h3>
      <p v-for="group of interesting_groups" :key="group.build">
        <strong>
          Group <a :href="group.link">{{ group.build }}</a></strong
        >
        (<span v-for="(element, index) in group.summary" :key="element"
          ><span v-if="index != 0">, </span><mark>{{ element }}</mark></span
        >)
      </p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'IncidentBuildSummaryComponent',
  props: {build: {type: String, required: true}, jobs: {type: Array, required: true}},
  computed: {
    number_of_passed: function () {
      return this.jobs.filter(function (job) {
        return job.status == 'passed';
      }).length;
    },
    interesting_groups: function () {
      const groups = new Map();
      const links = new Map();
      for (const job of this.jobs) {
        if (job.status == 'passed') continue;
        const key = job.job_group + '@' + job.flavor;
        if (!groups.get(key)) {
          groups.set(key, new Map());
          links.set(key, {
            version: job.version,
            groupid: job.group_id,
            flavor: job.flavor,
            distri: job.distri,
            build: job.build
          });
        }
        groups.get(key).set(job.status, (groups.get(key).get(job.status) || 0) + 1);
      }
      const ret = new Array();
      for (let [build, stat] of groups) {
        const summary = new Array();
        for (const [key, value] of stat.entries()) {
          summary.push(value + ' ' + key);
        }
        const searchParams = new URLSearchParams(links.get(build));
        ret.push({build: build, link: this.$openqa_url + '?' + searchParams.toString(), summary: summary.sort()});
      }
      return ret.sort((a, b) => a.build.localeCompare(b.build));
    }
  }
};
</script>
