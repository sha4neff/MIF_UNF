
#Область ПрограммныйИнтерфейс

// См. процедуру ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы.
//
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	ЭтоМобильныйКлиент = Ложь;
	
	#Если МобильныйКлиент Тогда
		ЭтоМобильныйКлиент = Истина;
	#КонецЕсли
	
	Если НЕ ЭтоМобильныйКлиент И НастройкиПубликацииМЛКВызовСервера.НеобходимоОткрытьФормуОпросаПоКК() Тогда
		
		ОткрытьФорму("ОбщаяФорма.ФормаОпросаПользователейМЛК");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
