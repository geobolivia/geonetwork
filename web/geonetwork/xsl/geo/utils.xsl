<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      exclude-result-prefixes="xs"
      version="2.0">

    <!-- Insert all required JS and CSS files:
    * Ext
    * Openlayers
    * GeoExt
    * GeoNetwork specific JS
    
    If debugging, you should add a debug parameter to your URL in order to load non compressed JS files.
    If changes are made to JS files, jsbuild tool need to be run in order to update geo-libs.js file. 
    JS files are compressed using jsbuild tool (see jsbuild directory).
    -->
    <xsl:template name="geoHeader">
        <script src="../../scripts/ext/adapter/ext/ext-base.js" type="text/javascript"/>
        <script src="../../scripts/ext/ext-all.js"  type="text/javascript"/>

        <link rel="stylesheet" type="text/css" href="../../scripts/ext/resources/css/ext-all.css"/>
        <link rel="stylesheet" type="text/css" href="../../scripts/geoext/resources/css/geoext-all-debug.css"/>
        <link rel="stylesheet" type="text/css" href="../../scripts/openlayers/theme/geonetwork/style.css"/>
        
        <script src="../../scripts/geo/proj4js-compressed.js" type="text/javascript"/>

        <xsl:choose>
            <xsl:when test="/root/request/debug">
                <script src="../../scripts/openlayers/OpenLayers.js" type="text/javascript"/>
                <script src="../../scripts/geoext/lib/GeoExt.js" type="text/javascript"/>
                <script src="../../scripts/geo/extentMap.js" type="text/javascript"/>
                <!--<script src="../../scripts/geo/app.FeatureSelectionPanel.js" type="text/javascript"/>-->
            </xsl:when>
            <xsl:otherwise>
                <script src="../../scripts/geo/geo-libs.js" type="text/javascript"/>
            </xsl:otherwise>
        </xsl:choose>
        
        <xsl:apply-templates mode="proj4init" select="/root/gui/config/map/proj"/>
        
        <xsl:call-template name="extentViewerJavascriptInit"/>
        
        <xsl:call-template name="css"/>
    </xsl:template>
    
    <xsl:template name="css">
        <style type="text/css">
            .drawPolygon {
            background-image:url(<xsl:value-of select="/root/gui/url"/>/images/draw_polygon_off.png) !important;
            }
            .drawCircle {
            background-image:url(<xsl:value-of select="/root/gui/url"/>/images/draw_circle_off.png) !important;
            }
            .drawRectangle {
            background-image:url(<xsl:value-of select="/root/gui/url"/>/images/draw_rectangle_off.png) !important;
            }
            .clearPolygon {
            background-image:url(<xsl:value-of select="/root/gui/url"/>/images/draw_polygon_clear_off.png) !important;
            }
        </style>
    </xsl:template>
    
    
    <!-- Create Javascript projection definition. -->
    <xsl:template mode="proj4init" match="proj">
        <script language="JavaScript1.2" type="text/javascript">
            <xsl:for-each select="crs[@def!='']">
                Proj4js.defs["<xsl:value-of select="@code"/>"] = "<xsl:value-of select="@def"/>";                
            </xsl:for-each>
        </script>
    </xsl:template>
    
    
    <!-- Init all maps. -->
    <xsl:template name="extentViewerJavascriptInit">
        <script language="JavaScript1.2" type="text/javascript">
            if( Ext )
              Ext.onReady(extentMap.initMapDiv)
            else
              Event.observe(window,'load',extentMap.initMapDiv);
        </script>
    </xsl:template>
</xsl:stylesheet>