<%--
 ~ Copyright (c) 2005-2010, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 ~
 ~ WSO2 Inc. licenses this file to you under the Apache License,
 ~ Version 2.0 (the "License"); you may not use this file except
 ~ in compliance with the License.
 ~ You may obtain a copy of the License at
 ~
 ~    http://www.apache.org/licenses/LICENSE-2.0
 ~
 ~ Unless required by applicable law or agreed to in writing,
 ~ software distributed under the License is distributed on an
 ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 ~ KIND, either express or implied.  See the License for the
 ~ specific language governing permissions and limitations
 ~ under the License.
 --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://wso2.org/projects/carbon/taglibs/carbontags.jar" prefix="carbon" %>
<%@ taglib uri="http://www.owasp.org/index.php/Category:OWASP_CSRFGuard_Project/Owasp.CsrfGuard.tld" prefix="csrf" %>

<script type="text/javascript" src="../yui/build/utilities/utilities.js"></script>
<jsp:include page="../registry_common/registry_common-i18n-ajaxprocessor.jsp"/>
<script type="text/javascript" src="../registry_common/js/registry_validation.js"></script>
<fmt:bundle basename="org.wso2.carbon.registry.extensions.ui.i18n.Resources">
<%
    if (request.getParameter("errorUpload") != null) {
%>
        <script type="text/javascript">
            CARBON.showWarningDialog("<fmt:message key="unable.to.upload.extension"/>");
        </script>
<%
    }
%>
<script type="text/javascript">

    var callback =
    {
        success:handleSuccess,
        failure:handleFailure
    };

    function handleSuccess(o) {
        window.location = "../extensions/list_extensions.jsp?region=region3&item=list_extensions_menu";
    }

    function handleFailure(o) {
        var buttonRow = document.getElementById('buttonRow');
        var waitMessage = document.getElementById('waitMessage');

        buttonRow.style.display = "";
        waitMessage.style.display = "none";
        if (o.responseText) {
            CARBON.showErrorDialog("<fmt:message key="unable.to.upload.extension"/> "+o.responseText);
        } else {
            CARBON.showErrorDialog("<fmt:message key="unable.to.upload.extension"/>");
        }
    }

    function submitUploadForm() {
        var form = document.getElementById("extensionUploadForm");
        form.submit();
    }

    function addExtension() {
        var reason = "";
        var addSelector = document.getElementById('addMethodSelector');

        var uResourceFile = document.getElementById('uResourceFile');
        var uResourceName = document.getElementById('uResourceName');

        //reason += validateEmpty(uResourceFile, "<fmt:message key="extension.file"/>");
        if (uResourceFile.value == null || uResourceFile.value == "") {
            reason += org_wso2_carbon_registry_common_ui_jsi18n["the.required.field"] + " "+
                      "<fmt:message key="extension.file"/>"+
                      " " + org_wso2_carbon_registry_common_ui_jsi18n["not.filled"] + "<br />";
        }

        if (reason != "") {
            CARBON.showWarningDialog(reason);
            return;
        }

        submitUploadForm();
    }

    function fillResourceUploadDetails() {
        var filePath = document.getElementById('uResourceFile').value;
        var filename = resolveFileName(filePath);

        if (filename.search(/\.jar$/i) < 0) {
            document.getElementById('uResourceFile').value = "";
            CARBON.showWarningDialog("<fmt:message key="only.filetypes.allowed"/>");
        }

        document.getElementById('uResourceName').value = filename;
    }

    function resolveFileName(filepath) {
        var filename = "";
        if (filepath.indexOf("\\") != -1) {
            filename = filepath.substring(filepath.lastIndexOf('\\') + 1, filepath.length);
        } else {
            filename = filepath.substring(filepath.lastIndexOf('/') + 1, filepath.length);
        }
        return filename;
    }

</script>
    <carbon:breadcrumb
            label="extensions.add.menu.text"
            resourceBundle="org.wso2.carbon.registry.extensions.ui.i18n.Resources"
            topPage="true"
            request="<%=request%>"/>
    <script type="text/javascript">
    </script>
    <div id="middle">

        <h2><fmt:message key="add.extension"/></h2>
        <div id="workArea">

                <table class="styledLeft">
                    <thead>
                    <tr>
                        <th><fmt:message key="add.extension.table.heading"/></th>
                    </tr>
                    </thead>

                    <tr>
                        <td class="formRow">
                            <table width="100%">
                                <tr>
                                    <td>
                                        <div id="uploadUI">
                                            <form method="post"
                                                  name="extensionUploadForm"
                                                  id="extensionUploadForm"
                                                  action="../../fileupload/registryextensions?<csrf:tokenname/>=<csrf:tokenvalue/>"
                                                  enctype="multipart/form-data" target="_self">
                                                 <input type="hidden" id="uRedirect" name="redirect" value="extensions/list_extensions.jsp?region=region3&item=list_extensions_menu"/>
                                                 <input type="hidden" id="uErrorRedirect" name="errorRedirect" value="extensions/add_extensions.jsp?errorUpload=errorUpload"/>
                                                 <input type="hidden" name="filename" id="uResourceName"/>

                                                 <table class="normal">
                                                    <tr>
                                                        <td><fmt:message key="extension.file"/> <span class="required">*</span></td>
                                                        <td> <p>
                                                             <input id="uResourceFile" type="file" name="upload" size="50"
                                                                    style="background-color:#cccccc"
                                                                    onchange="fillResourceUploadDetails()"
                                                                    onkeypress="return blockManual(event)"/>
                                                            </p>
                                                            <p>
                                                                <fmt:message key="possible.uploadable.formats"/>
                                                            </p>
                                                        </td>
                                                    </tr>
                                                </table>

                                             </form>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr id="buttonRow">
                        <td class="buttonRow">
                            <input class="button registryWriteOperation" type="button" onClick="addExtension();"
                                   value='<fmt:message key="upload"/>'/>
                            <input class="button registryNonWriteOperation" type="button" disabled="disabled"
                                   value='<fmt:message key="upload"/>'/>
                            <input class="button" type="button" onClick="window.location = '../extensions/list_extensions.jsp?region=region3&item=list_extensions_menu';"
                                   value='<fmt:message key="cancel"/>'/>
                        </td>
                    </tr>
                    <tr id="waitMessage" style="display:none">
                        <td>
                            <div style="font-size:13px !important;margin-top:10px;margin-bottom:10px;margin-left:5px !important" class="ajax-loading-message"><img
                                    src="images/ajax-loader.gif" align="left" hspace="20"/><fmt:message key="please.wait.until.extension.is.added"/>...
                            </div>
                        </td>
                    </tr>
                </table>
        </div>
    </div>
</fmt:bundle>
