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


export interface CommonDataForAppointmentCreation { 
    activities?: Array<CommonActivity>;
    clients?: Array<CommonClient>;
    employees?: Array<CommonEmployee>;
    places?: Array<string>;
}

