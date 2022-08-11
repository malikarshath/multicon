import { LightningElement,api } from 'lwc';

export default class EmployeeTile extends LightningElement {
    
    @api selectedEmployeeId = "";
    @api employee = {
        Name : "Abdul Malik Arshath",
        PhotoUrl : "/services/images/photo/003B0FakePictId"
    };
    @api isSelected = false;

    get tileSelected(){
        return this.selectedEmployeeId === this.employee.Id ? "tileSelected" : "tile";
    }
    employeeClick(){
        const evt = new CustomEvent("employeeselected", {
            bubbles: true,
            composed: true,
            detail: { employeeId: this.employee.Id }
        });
        this.dispatchEvent(evt);
    }

}