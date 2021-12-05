<template>
    <div class="card">
          <div class="card-body text-left">
              <h3 cass='card-title d-flex'>Build {{ build }} ({{ number_of_passed }} passed)</h3>
              <p v-for="group of interesting_groups" v-bind:key="group.build"><strong>
                  Group <a v-bind:href="group.link">{{group.build}}</a></strong> (<span v-for="(element, index) in group.summary" 
                        v-bind:key="element"><span v-if="index != 0">, </span><mark>{{ element }}</mark></span>)
              </p>
          </div>
        </div>
</template>

<script>
module.exports = {
    props: ['build', 'jobs'],
    computed: {
        number_of_passed: function() {
            return this.jobs.filter(function(job) { 
                return job.status == 'passed'}
                ).length;
        },
        interesting_groups: function() {
            let groups = new Map();
            let links = new Map();
            for (const job of this.jobs) {
                if (job.status == 'passed') continue;
                let key = job.job_group + "@" + job.flavor;
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
            let ret = new Array();
            for (let [build, stat] of groups) {
                let summary = new Array();
                for (const [key, value] of stat.entries()) {
                     summary.push(value + " " + key);
                }
                const searchParams = new URLSearchParams(links.get(build));
                ret.push({build: build,
                          link: openqa_url + "?" + searchParams.toString(),
                          summary: summary.sort()});
            }
            return ret.sort((a,b) => a.build.localeCompare(b.build));
        }
    }
}
</script>