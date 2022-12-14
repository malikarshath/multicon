import { LightningElement, wire } from 'lwc';
import getProjects from '@salesforce/apex/EmployeeBrowserForm.getProjects';
import getProjectSkills from '@salesforce/apex/EmployeeBrowserForm.getProjectSkills';

export default class EmployeeBrowserForm extends LightningElement {
    projects = [];
    error;
    selectedProjectId = '';
    projectSkills = [];
    selectedProjectSkillId = '';
    @wire(getProjects)
    wired_getProjects({ error, data }) {
        this.projects = [];
        if (data) {
            this.projects.push({
                value: '',
                label: 'Select an project'
            });
            data.forEach(project => {
                this.projects.push({
                    value: project.Id,
                    label: project.Project_Name__c
                });
            });

        } else if (error) {
            this.error = error;
        }
    }
    @wire(getProjectSkills, { projectId: '$selectedProjectId' })
    wired_getProjectSkillsByProject({ error, data }) {
        this.projectSkills = [];
        if (data && data.length) {
            this.projectSkills = data.map(projectSkill => ({
                value: projectSkill.Id,
                label: projectSkill.Name
            }));
            this.projectSkills.unshift({
                value: '',
                label: 'Select an project skill'
            });
        } else if (error) {
            this.error = error;
        }
    }
    onProjectChange(event) {
        this.selectedProjectSkillId = '';
        this.selectedProjectId = event.target.value;
        this.notifyParent();

    }
    onProjectSkillChange(event){
        this.selectedProjectSkillId = event.target.value;
        this.notifyParent();
    }
    notifyParent() {
        const evt = new CustomEvent('filterchange', {
            detail: {
                projectId: this.selectedProjectId,
                projectSkillId: this.selectedProjectSkillId,
            }
        });
        this.dispatchEvent(evt);
    }
}