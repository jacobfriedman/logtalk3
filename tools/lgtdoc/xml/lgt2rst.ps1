#############################################################################
##
##   XML documenting files to reStructuredText files conversion script
##   Last updated on March 23, 2025
##
##   This file is part of Logtalk <https://logtalk.org/>
##   Copyright 2022-2025 Paulo Moura <pmoura@logtalk.org>
##   Copyright 2022 Hans N. Beck
##   SPDX-License-Identifier: Apache-2.0
##
##   Licensed under the Apache License, Version 2.0 (the "License");
##   you may not use this file except in compliance with the License.
##   You may obtain a copy of the License at
##
##       http://www.apache.org/licenses/LICENSE-2.0
##
##   Unless required by applicable law or agreed to in writing, software
##   distributed under the License is distributed on an "AS IS" BASIS,
##   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##   See the License for the specific language governing permissions and
##   limitations under the License.
##
#############################################################################


#Requires -Version 7.3

[CmdletBinding()]
param(
	[Parameter()]
	[String]$d = $pwd,
	[String]$i = "index.rst",
	[String]$t = "Documentation index",
	[String]$l = "",
	[Switch]$s,
	[Switch]$m,
	[Switch]$v,
	[Switch]$h
)

function Write-Script-Version {
	$myFullName = $MyInvocation.ScriptName
	$myName = Split-Path -Path $myFullName -leaf -Resolve
	Write-Output "$myName 5.2"
}

function Write-Usage-Help() {
	$myFullName = $MyInvocation.ScriptName
	$myName = Split-Path -Path "$myFullName" -leaf -Resolve

	Write-Output "This script converts all Logtalk XML documenting files in the"
	Write-Output "current directory to reStructuredText files for use with Sphinx"
	Write-Output ""
	Write-Output "Usage:"
	Write-Output "  $myName [-d directory] [-i index] [-t title] [-s] [-m] [-l mapping]"
	Write-Output "  $myName -v"
	Write-Output "  $myName -h"
	Write-Output ""
	Write-Output "Optional arguments:"
	Write-Output "  -d output directory for the generated files (default is $d)"
	Write-Output "  -i name of the index file (default is $i)"
	Write-Output "  -t title to be used in the index file (default is `"$t`")"
	Write-Output "  -s run sphinx-quickstart script"
	Write-Output "  -m run make html (requires also using the -s option)"
	Write-Output "  -l Intersphinx mapping for linking library APIs to library descriptions (requires -s option)"
	Write-Output "  -v print version"
	Write-Output "  -h help"
	Write-Output ""
}

function Confirm-Parameters() {

	if (-not(Test-Path $d)) { # cannot be ""
		Write-Error "The $d output directory does not exist!"
		Start-Sleep -Seconds 2
		Exit 1
	}

	if ($v -eq $true) {
		Write-Script-Version
		Exit 0
	}

	if ($h -eq $true) {
		Write-Usage-Help
		Exit 0
	}

}

function New-Index-File() {
	New-Item -Path . -Name "$i" -ItemType "file" -Force > $null

	Add-Content -Path "$i" -Value ""
	Add-Content -Path "$i" -Value $t
	$underline = "=" * $t.Length
	Add-Content -Path "$i" -Value $underline
	Add-Content -Path "$i" -Value ""
	Add-Content -Path "$i" -Value ""

	if (Test-Path "directory_index.xml") {
		Add-Content -Path "$i" -Value ".. toctree::"
		Add-Content -Path "$i" -Value "   :maxdepth: 3"
		Add-Content -Path "$i" -Value "   :caption: Contents"
		Add-Content -Path "$i" -Value ""
		Add-Content -Path "$i" -Value "   library_index"
		Add-Content -Path "$i" -Value "   directory_index"
		Add-Content -Path "$i" -Value "   entity_index"
		Add-Content -Path "$i" -Value "   predicate_index"
		Add-Content -Path "$i" -Value ""
		Add-Content -Path "$i" -Value "Indices and tables"
		Add-Content -Path "$i" -Value "=================="
		Add-Content -Path "$i" -Value ""
		Add-Content -Path "$i" -Value '* :ref:`genindex`'
		Add-Content -Path "$i" -Value '* :ref:`search`'
	} elseif (Get-ChildItem -Path . -Filter .\*.xml | Select-String -Pattern '<logtalk_entity' -CaseSensitive -SimpleMatch -Quiet) {
		Add-Content -Path "$i" -Value ".. toctree::"
		Add-Content -Path "$i" -Value "   :maxdepth: 1"
		Add-Content -Path "$i" -Value ""
		Get-ChildItem -Path . -Filter .\*.xml |
		Foreach-Object {
			if ($_ | Select-String -Pattern '<logtalk_entity' -CaseSensitive -SimpleMatch -Quiet) {
				$entity = ($_.BaseName -replace '_[^_]*$')
				$pars   = ($_.BaseName -replace '.*_')
				Write-Output "  indexing $($_.BaseName).rst"
				if ($pars -ne "" -and [int]$pars -gt 0) {
					Add-Content -Path "$i" -Value "   $entity/$pars <$($_.BaseName)>"
				} else {
					Add-Content -Path "$i" -Value "   $entity <$($_.BaseName)>"
				}
			}
		}
	}

	$date = Get-Date -Format "ddd MMM dd HH:mm:ss K yyyy"

	Add-Content -Path "$i" -Value ""
	Add-Content -Path "$i" -Value "Generated on $date"
}

###################### here it starts ############################

Import-Module (Join-Path $PSScriptRoot "LogtalkSetupEnv.psm1")
Initialize-LogtalkEnvironment

Confirm-Parameters

$entity_xslt = "$env:LOGTALKUSER/tools/lgtdoc/xml/logtalk_entity_to_rst.xsl"
$index_xslt  = "$env:LOGTALKUSER/tools/lgtdoc/xml/logtalk_index_to_rst.xsl"

if (!(Test-Path "logtalk_entity.dtd")) {
	Copy-Item -Path "$env:LOGTALKHOME/tools/lgtdoc/xml/logtalk_entity.dtd" -Destination .
}

if (!(Test-Path "logtalk_index.dtd")) {
	Copy-Item -Path "$env:LOGTALKHOME/tools/lgtdoc/xml/logtalk_index.dtd" -Destination .
}

if (!(Test-Path "custom.ent")) {
	Copy-Item -Path "$env:LOGTALKUSER/tools/lgtdoc/xml/custom.ent" -Destination .
}

if (!(Test-Path "logtalk_entity.xsd")) {
	Copy-Item -Path "$env:LOGTALKHOME/tools/lgtdoc/xml/logtalk_entity.xsd" -Destination .
}

if (!(Test-Path "logtalk_index.xsd")) {
	Copy-Item -Path "$env:LOGTALKHOME/tools/lgtdoc/xml/logtalk_index.xsd" -Destination .
}

if (Select-String -Path .\*.xml -Pattern '<logtalk' -CaseSensitive -SimpleMatch -Quiet) {
	Write-Output "Converting XML files to reStructuredText files..."

	$xslt_settings = New-Object System.Xml.Xsl.XsltSettings
	$xslt_settings.EnableDocumentFunction = $true

	$xml_reader_settings = New-Object System.Xml.XmlReaderSettings
	$xml_reader_settings.DtdProcessing = [System.Xml.DtdProcessing]::Ignore

	$xml_url_resolver = New-Object System.Xml.XmlUrlResolver

	$entity_xslt_object = New-Object System.Xml.Xsl.XslCompiledTransform
	$entity_xslt_object.Load($entity_xslt, $xslt_settings, $xml_url_resolver)

	$index_xslt_object = New-Object System.Xml.Xsl.XslCompiledTransform;
	$index_xslt_object.Load($index_xslt, $xslt_settings, $xml_url_resolver)

	if ($l) {
		$xslArguments = New-Object System.Xml.Xsl.XsltArgumentList
		$xslArguments.AddParam("mapping", [string]::Empty, $l)
	} else {
		$xslArguments = $null;
	}

	Get-ChildItem -Path . -Filter *.xml |
	Foreach-Object {
		if (Select-String -Path $_ -Pattern '<logtalk_entity' -CaseSensitive -SimpleMatch -Quiet) {
			Write-Output "  converting $($_.Name)"
			$file = Join-Path "$pwd" "$($_.Name)"
			$rst = Join-Path $d "$($_.BaseName).rst"
			$reader = [System.Xml.XmlReader]::Create($file, $xml_reader_settings)
			$fs = New-Object IO.FileStream $rst, 'Append', 'Write', 'Read'
			$writer = New-Object System.IO.StreamWriter($fs)
			$entity_xslt_object.Transform($reader, $xslArguments, $writer)
			$writer.Close()
			$reader.Dispose()
		}
	}
	Get-ChildItem -Path . -Filter .\*.xml |
	Foreach-Object {
		if (Select-String -Path $_ -Pattern '<logtalk_index' -CaseSensitive -SimpleMatch -Quiet) {
			Write-Output "  converting $($_.Name)"
			$file = Join-Path "$pwd" "$($_.Name)"
			$rst = Join-Path "$d" "$($_.BaseName).rst"
			$reader = [System.Xml.XmlReader]::Create($file, $xml_reader_settings)
			$fs = New-Object IO.FileStream $rst, 'Append', 'Write', 'Read'
			$writer = New-Object System.IO.StreamWriter($fs)
			$index_xslt_object.Transform($reader, $xslArguments, $writer)
			$writer.Close()
			$reader.Dispose()
		}
	}
	Write-Output "conversion done"
	Write-Output ""
	Write-Output "generating $i file..."
	New-Index-File
	Write-Output "$i file generated"
	Write-Output ""
	if ($s -eq $true) {
		Move-Item -Path index.rst -Destination index.rst.backup -Force
		sphinx-quickstart --templatedir="$env:LOGTALKUSER/tools/lgtdoc/xml"
		if (-not (Test-Path _static/css)) {
			New-Item -Path _static/css -ItemType Directory > $null
		}
		Copy-Item -Path "$env:LOGTALKUSER/tools/lgtdoc/xml/css/sphinx/custom.css" -Destination _static/css/custom.css
		Move-Item -Path index.rst.backup -Destination index.rst -Force
	}
	if ($s -eq $true -and $m -eq $true) {
		.\make html
	}
} else {
	Write-Output ""
	Write-Output "No XML files exist in the current directory!"
	Write-Output ""
}
