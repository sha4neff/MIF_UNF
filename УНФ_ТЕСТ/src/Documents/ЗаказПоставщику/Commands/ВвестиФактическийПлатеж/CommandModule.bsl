
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", ПараметрКоманды);
	
	Если ПараметрыВыполненияКоманды.Источник.Элементы.Найти("РедактироватьСписком") <> Неопределено 
		И ПараметрыВыполненияКоманды.Источник.Объект.ЗапланироватьОплату Тогда
		
		Если ПараметрыВыполненияКоманды.Источник.Элементы.РедактироватьСписком.Пометка Тогда
			ПлатежныйКалендарьТекущаяСтрока = ПараметрыВыполненияКоманды.Источник.Элементы.СписокПлатежныйКалендарь.ТекущиеДанные;
		ИначеЕсли ПараметрыВыполненияКоманды.Источник.Объект.ПлатежныйКалендарь.Количество() > 0 Тогда
			ПлатежныйКалендарьТекущаяСтрока = ПараметрыВыполненияКоманды.Источник.Объект.ПлатежныйКалендарь[0];
		КонецЕсли;
		
		Если ПлатежныйКалендарьТекущаяСтрока <> Неопределено Тогда
			
			СтруктураЗаполнения = Новый Структура();
			СтруктураЗаполнения.Вставить("Основание", ПараметрКоманды);
			СтруктураЗаполнения.Вставить("НомерСтроки", ПлатежныйКалендарьТекущаяСтрока.НомерСтроки);
			ПараметрыФормы.Вставить("Основание", СтруктураЗаполнения);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ТипДенежныхСредств = ПолучитьТипДенежныхСредств(ПараметрКоманды);
	
	Если ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Наличные") Тогда
		ИмяФормы = "Документ.РасходИзКассы.ФормаОбъекта";
	Иначе
		ИмяФормы = "Документ.РасходСоСчета.ФормаОбъекта";
	КонецЕсли;
	
	ОткрытьФорму(ИмяФормы,
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка
	);
	
	СтатистикаИспользованияФормКлиент.ПроверитьЗаписатьСтатистикуКоманды(
		"СоздатьНаОсновании.ВвестиФактическийПлатеж",
		ПараметрыВыполненияКоманды.Источник
	);

КонецПроцедуры // ОбработкаКоманды()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьТипДенежныхСредств(ДокументСсылка)
	
	Возврат ДокументСсылка.ТипДенежныхСредств;
	
КонецФункции // ПолучитьТипДенежныхСредств()

#КонецОбласти


