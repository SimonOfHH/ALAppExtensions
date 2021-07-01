// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// Exposes functionality to handle the creation of an Account SAS (Shared Access Signature)
/// More Information: https://docs.microsoft.com/en-us/rest/api/storageservices/create-account-sas
/// </summary>
interface "Storage Serv. Auth. SAS"
{
    /// <summary>
    /// Sets the key which is used to sign the generated SAS (Shared Access Signature)
    /// </summary>
    /// <param name="NewSigningKey">The Access Key to sign the SAS</param>
    procedure SetSigningKey(NewSigningKey: Text);

    /// <summary>
    /// Sets the start and end date/time for which this SAS (Shared Access Signature) is valid
    /// </summary>
    /// <param name="NewStartDate">DateTime specifying the start</param>
    /// <param name="NewEndDate">DateTime specifying the expiry</param>
    procedure SetDatePeriod(NewStartDate: DateTime; NewEndDate: DateTime);

    /// <summary>
    /// Sets the IP Range from which a request will be accepted (e.g. 168.1.5.60-168.1.5.70)
    /// </summary>
    /// <param name="NewIPRange">Value (as Text) specifying the IP Range</param>
    procedure SetIPrange(NewIPRange: Text);

    /// <summary>
    /// Adds an entry to the list of allowed services for the SAS that is to be generated
    /// </summary>
    /// <param name="ServiceType">Value of Enum "Storage Service Type" specifying the used service</param>
    procedure AddService(ServiceType: Enum "Storage Service Type");

    /// <summary>
    /// Adds an entry to the list of allowed resources for the SAS that is to be generated
    /// </summary>
    /// <param name="ResourceType">Value of Enum "Storage Service Resource Type" specifying the used resource</param>
    procedure AddResource(ResourceType: Enum "Storage Service Resource Type");

    /// <summary>
    /// Adds an entry to the list of allowed permissions for the SAS that is to be generated
    /// </summary>
    /// <param name="Permission">Value of Enum "Storage Service Permission" specifying the used permission</param>
    procedure AddPermission(Permission: Enum "Storage Service Permission");

    /// <summary>
    /// Adds an entry to the list of allowed protocols for the SAS that is to be generated
    /// Allowed values are: http, https
    /// </summary>
    /// <param name="ResourceType">Value (as Text) specifying the used protocols</param>
    procedure AddProtocol(Protocol: Text);

    /// <summary>
    /// Creates a Storage Service authorization.
    /// </summary>
    /// <returns>SAS implementation on Storage Service Authorization.</returns>
    procedure AsStorageServiceAuthorization(): Interface "Storage Service Authorization";
}