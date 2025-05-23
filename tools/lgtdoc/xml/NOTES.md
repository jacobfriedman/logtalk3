________________________________________________________________________

This file is part of Logtalk <https://logtalk.org/>  
SPDX-FileCopyrightText: 1998-2025 Paulo Moura <pmoura@logtalk.org>  
SPDX-License-Identifier: Apache-2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
________________________________________________________________________


This folder contains supporting files for converting and/or indexing XML
documenting files (which are created using the `lgtdoc` tool) to final
formats such as PDF, ePub, (X)HTML, reStructuredText, Markdown, and plain
text files using XSL style sheets. The documenting files may also be
viewed directly on a web browser that supports the W3C standards XML,
XSLT, CSS, and HTML 4 or XHTML 1.0.

The shell and command-line scripts should be called from the directory
containing the XML documenting files that you wish to convert. See the
description of each script below for details. The `.sh` files are Bash
shell scripts for POSIX systems. The `.ps1` are PowerShell scripts for
Windows. These scripts assume that the `LOGTALKHOME` and `LOGTALKUSER`
environment variables are defined and that the chosen XSLT processor is
available in the path.

**MAKE SURE THAT THE XSL PROCESSORS AND ANY ADDITIONAL THIRD-PARTY SOFTWARE
YOU INTEND TO USE ARE PROPERLY INSTALLED AND WORKING BEFORE RUNNING THESE
SCRIPTS!**

Regarding conversion to (X)HTML, the links to the XSL files on the XML
files and the links to the CSS files in the generated HTML files assume
that all files reside in the same directory.

The default XSL files to use (`logtalk_entity_to_xml.xsl` and
`logtalk_index_to_xml.xsl`, described below) are set in the `lgtdoc` tool.
You may choose a different default XSL files by using the `entity_xsl_file/1`
and `index_xsl_file/1` options.

The documenting files can be generated either as standalone XML files or
containing a reference to either the Logtalk DTD files, `logtalk_entity.dtd`
and `logtalk_index.dtd`, or to the Logtalk XML Schema files, `logtalk_entity.xsd`
and `logtalk_index.xsd`. The reference to the XML specification files can be
either a local reference or a URI reference. By default, all XML documenting
files contain a local reference but that can be changed by using the
`xml_spec_reference/1` option. Choose the option value that works best with your
XSLT tools. To choose between the DTD or XSD specifications use the `xml_spec/1`
option.

As Logtalk uses a single namespace for all objects, categories, and protocols,
you may want to define an alternate, global compilation directory to store all
the XML documenting files, thus ensuring proper working of links to other
entities in the generated (X)HTML files. See the sample settings file in your
Logtalk user folder for details.


Brief description of each directory and file in this folder:

- `css`  
	Directory with CSS files for use with generated human readable
	documentation such as Sphinx

- `logtalk_entity_to_xml.xsl`  
- `logtalk_index_to_xml.xsl`  
	XSLT file for viewing XML files directly in a browser. The links
	in the (internally generated) HTML 4.01 files point to related XML
	files. UTF-8 encoding is assumed. Edit the file if you use a different
	encoding.

- `logtalk_entity_to_html.xsl`  
- `logtalk_index_to_html.xsl`  
	XSLT file to output HTML 4.01 files from the XML files. The links in
	the generated HTML files point to related HTML files. UTF-8 encoding
	is assumed. Edit the file if you use a different encoding. This XSLT
	file adds anchors to each predicate section using as name the predicate
	indicator.

- `logtalk_entity_to_xhtml.xsl`  
- `logtalk_index_to_xhtml.xsl`  
	XSLT file to output XHTML 1.1 files from the XML files. The links in
	the generated XHTML files point to related XHTML files. UTF-8 encoding
	is assumed. Edit the file if you use a different encoding. This XSLT
	file adds anchors to each predicate section using as name the predicate
	indicator.

- `logtalk_entity_to_md.xsl`  
- `logtalk_index_to_md.xsl`  
	XSLT file to output Markdown text files from the XML files. UTF-8 encoding
	is assumed. Edit the file if you use a different encoding.

- `logtalk_entity_to_rst.xsl`  
- `logtalk_index_to_rst.xsl`  
	XSLT file to output reStructuredText files (for use with Sphinx) from the
	XML files. UTF-8 encoding is assumed. Edit the file if you use a different
	encoding.

- `logtalk_entity_to_txt.xsl`  
- `logtalk_index_to_txt.xsl`  
	XSLT file to output simple text files from the XML files. UTF-8 encoding
	is assumed. Edit the file if you use a different encoding.

- `logtalk_entity_to_pdf.xsl`  
- `logtalk_entity_to_pdf_a4.xsl`  
- `logtalk_entity_to_pdf_us.xsl`  
	XSLT files to generate PDF files from the XML files (formatted either
	for A4 paper or US Letter paper) using XSL Formatting Objects. Tested
	with the XSL-FO processors RenderX 4.4 (<http://www.renderx.com/>) and
	Apache FOP 0.94 (<http://xmlgraphics.apache.org/fop/>).

	The `logtalk_entity_to_pdf.xsl` file defines a parameter for the paper
	format (either A4 or US Letter). The files `logtalk_entity_to_pdf_a4.xsl`
	and `logtalk_entity_to_pdf_us.xsl` import the `logtalk_entity_to_pdf.xsl`
	file and set the paper format parameter to the appropriate value.

- `logtalk_entity.dtd`  
- `logtalk_index.dtd`  
	DTD files describing the structure of the entity and index XML files
	generated by Logtalk documenting tools.

- `custom.ent`  
	Document type description defining XML entities for personal data
	that may be used on Logtalk documenting directives.

- `logtalk_entity.rng`  
- `logtalk_index.rng`  
	RELAX NG file describing the structure of the entity and index XML
	files by Logtalk documenting tools.

- `logtalk_entity.xsd`  
- `logtalk_index.xsd`  
	XML Schema file describing the structure of the entity and index XML
	files generated by Logtalk documenting tools.

- `logtalk.css`  
	Cascade style sheet file to render the HTML/XHTML output of the XSL
	files in a web browser.

- `lgt2pdf.sh` and `lgt2pdf.ps1`  
	Sample scripts to batch convert XML files to PDF files

	Supported XSL-FO processors:  
		* [Apache FOP processor](http://xmlgraphics.apache.org/fop/) (tested with version 0.94)  
		* [RenderX XEP processor](http://www.renderx.com/) (tested with version 3.8.1)  

	FOP 2.x is also supported but requires generating the XML documentation
	files using the option `xml_spec(xsd)` or `xml_spec_reference(standalone)`.

	The scripts should be called from the directory containing the XML
	files you wish to convert. Call the scripts with the help option for
	a description of the available optional parameters (type `cscript
	lgt2pdf.js help` or `lgt2pdf.sh -h`; depending on your Logtalk
	installation, you may simply need to type `lgt2pdf` in order to run
	the script).

- `lgt2html.sh` and `lgt2html.ps1`  
	Sample scripts to batch convert XML files to HTML files. These
	scripts also generate an `index.html` file which contains links
	to all the converted files.

	Supported XSLT processors for Bash scripts:  
		* [xsltproc](https://gitlab.gnome.org/GNOME/libxslt/-/wikis/home) (tested with version 1.1.8)  
		* [Xalan](https://xml.apache.org/xalan-c/index.html) (tested with version 1.7.0)  
		* [Saxon](https://www.saxonica.com/) (tested with version 9.5.1.1; JAR version)  

	The PowerShell scripts use the .Net XSLT classes.

	The scripts should be called from the directory containing the XML files
	you wish to convert. Call the scripts with the help option for a description
	of the available optional parameters (type `lgt2html.sh -h` for help;
	depending on your Logtalk installation, you may simply need to type
	`lgt2html` in order to run the script).

- `lgt2xml.sh` and `lgt2xml.ps1`  

	Sample scripts for indexing the XML files in the current directory by
	generating an `index.html` file that contains links to all the files.
	In addition, these scripts also copy the used XML specs, XSL, and CSS
	files to the current directory, allowing direct visualization of the
	XML files on a supported web browser. Unfortunately, this does not work
	in recent versions of Google Chrome and Apple Safari using their default
	security settings.

	The scripts should be called from the directory containing the XML files
	you wish to index. Call the scripts with the help option for a description
	of the available optional parameters (type `lgt2xml.sh -h` for help;
	depending on your Logtalk installation, you may simply need to type
	`lgt2xml` in order to run the script).

- `lgt2md.sh` and `lgt2md.ps1`  
	Sample scripts to batch convert XML files to Markdown text files.

	The scripts should be called from the directory containing the XML files
	you wish to convert. Call the scripts with the help option for a description
	of the available optional parameters (type `lgt2md.sh -h` for help;
	depending on your Logtalk installation, you may simply need to type
	`lgt2md` in order to run the script).

- `lgt2rst.sh` and `lgt2rst.ps1`  
	Sample scripts to batch convert XML files to reStructuredText files and
	optionally generate Sphinx HTML files.

	The scripts should be called from the directory containing the XML files
	you wish to convert. Call the scripts with the help option for a description
	of the available optional parameters (type `lgt2rst.sh -h` for help;
	depending on your Logtalk installation, you may simply need to type
	`lgt2rst` in order to run the script). The generated files are expected
	to be used with Sphinx. Assuming that Sphinx and the  Read the Docs Sphinx
	theme are both installed, `lgt2rst -s` calls the `sphinx-quickstart`
	interactive script using the `conf.py.jinja` file in this directory as the
	`conf.py` template and using the `css/sphinx/custom.css` to customize
	the Read the Docs Sphinx Theme. You can edit the `conf.py.jinja` to
	customize it; see the Sphinx documentation for more details. To use the
	`sphinx-quickstart` script in non-interactive mode pass the options to
	it using the syntax `lgt2rst -s -- -q` followed by `-p`, `-a` and `-v`
	options. For example, `lgt2rst -s -- -q -p "My Project" -a "J. Doe" -v "1.12"`.
	This use in non-interactive mode is currently only supported by the
	`lgt2rst.sh` POSIX script. To add links from library APIs to library
	descriptions, update the used `conf.py` to define a Intersphinx mapping
	and optionally use the script `-l` option to explicitly qualify the links
	to the library descriptions. The library description files must have
	a reStructuredText target in the first line with the name of the library
	prefixed by `library_`.

	Required software:  
		* [Sphinx](https://www.sphinx-doc.org/) (tested with version 4.5.0)  
		* [Pygments](https://pygments.org/) (tested with version 2.11.2)

	Sphinx includes default themes. The Logtalk documentation uses the
	[Read the Docs theme](https://github.com/readthedocs/sphinx_rtd_theme)
	(tested with version 1.0.0) with some CSS changes.

- `lgt2txt.sh` and `lgt2txt.ps1`  
	Sample scripts to batch convert XML files to plain text files.

	The scripts should be called from the directory containing the XML files
	you wish to convert. Call the scripts with the help option for a description
	of the available optional parameters (type `lgt2txt.sh -h` for help;
	depending on your Logtalk installation, you may simply need to type
	`lgt2txt` in order to run the script).

Note that you can write other XSL files for converting the XML files to
other formats besides PDF or (X)HTML. You can also write alternative CSS
and XSL files to change the appearance of the (X)HTML and PDF files.
