<aura:application access="global">

   <aura:attribute name="display" type="Boolean" default="true"/>
    <ui:button aura:id="button" label="Click to toggle - React" press="{!c.toggle}"/>

    <aura:renderIf isTrue="{!v.display}">
        Lightning App with Lightning Component using React
        <aura:set attribute="else">
        Here's a Lightning component using React:
        	<c:ReactSearch />
        </aura:set>
    </aura:renderIf>

</aura:application>