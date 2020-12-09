export interface NewEmployee {
    id?: string;
    name?: string;
    phone?: string;
    email?: string;
    //activities?: Array<CommonActivity>;
}

export class AssignedActivity {
    id?: string;
    name?: string;
    assignedToEmployee: boolean;
}