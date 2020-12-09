/**
 * Timetic szervezeti backend
 * No description provided (generated by Openapi Generator https://github.com/openapitools/openapi-generator)
 *
 * The version of the OpenAPI document: 1.0.0
 * Contact: you@your-company.com
 *
 * NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
 * https://openapi-generator.tech
 * Do not edit the class manually.
 */
import { CommonEmployee } from './commonEmployee';
import { CommonClient } from './commonClient';
import { CommonActivity } from './commonActivity';


export interface CommonAppointment { 
    id?: string;
    isPrivate?: boolean;
    startTime?: number;
    endTime?: number;
    client?: CommonClient;
    activity?: CommonActivity;
    employee?: CommonEmployee;
    place?: string;
    price?: number;
    online?: boolean;
    note?: string;
}
