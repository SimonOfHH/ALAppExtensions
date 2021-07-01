// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// Exposes functionality to handle the creation of a signature to sign requests to the Storage Services REST API
/// More Information: https://docs.microsoft.com/en-us/rest/api/storageservices/authorize-with-shared-key
/// </summary>
interface "Storage Serv. Auth. Shared Key"
{
    /// <summary>
    /// Sets the Dictionary of HttpHeader Identifier/Value-combinations which will be use for signature-generation
    /// </summary>
    /// <param name="NewHeaderValues">Dictionary containing HttpHeader-Identifier and -values</param>
    procedure SetHeaderValues(NewHeaderValues: Dictionary of [Text, Text]);

    /// <summary>
    /// Sets the secre
    /// </summary>
    /// <param name="NewSecret"></param>
    procedure SetSecret(NewSecret: Text);

    /// <summary>
    /// Sets the API Version to be used for the desired operation
    /// </summary>
    /// <param name="NewApiVersion">Value of Enum "Storage service API Version" specifying the used version</param>
    procedure SetApiVersion(NewApiVersion: Enum "Storage service API Version");

    /// <summary>
    /// Creates a Storage Service authorization.
    /// </summary>
    /// <returns>Shared Key implementation on Storage Service Authorization.</returns>
    procedure AsStorageServiceAuthorization(): Interface "Storage Service Authorization";
}