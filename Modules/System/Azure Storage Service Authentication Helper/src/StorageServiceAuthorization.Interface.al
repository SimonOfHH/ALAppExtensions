// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

/// <summary>
/// Common interface for different authorization options.
/// </summary>
interface "Storage Service Authorization"
{
    /// <summary>
    /// Authorizes an operation by providing the needed information in the operation payload.
    /// </summary>
    /// <param name="OperationPayload">The operation to authorize.</param>
    procedure Authorize(OperationPayload: Interface "Storage Service REST Operation");
}